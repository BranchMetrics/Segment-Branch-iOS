//
//  EventViewController.swift
//  Fortune
//
//  Created by Edward on 2/5/18.
//  Copyright © 2018 Branch. All rights reserved.
//

import UIKit
import Analytics
import Branch

class EventViewController: UIViewController {
    @IBOutlet weak var segmentActionButton: UIButton!
    @IBOutlet weak var eventBodyTextView: UITextView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var menuView: APDropDownMenu?

    private
    var keyboardEditor: APKeyboardEditor?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectSegmentEvent(selection: "")
    }

    // MARK: - Pick Action

    @IBAction func pickSegmentAction(sender: AnyObject) {
        if self.menuView != nil { return }

        let actions = [
            "Set Identity",
            "Set Alias",
            "Reset Identity",
            "Track Event",
            "Track Screen",
        ]
        self.menuView = APDropDownMenu.init(
            view: self.segmentActionButton,
            position: [.bottom, .left],
            items: actions,
            selectedItem: -1,
            completion: { (menu, selectedItem) in
                if selectedItem < 0 {
                    self.menuView = nil
                    return
                }
                self.eventNameLabel.text = actions[selectedItem]
                self.eventBodyTextView.text = ""

                switch selectedItem {
                case 0:
                    self.promptForIdentity(completion: { (name) in
                        if let name = name, name.count > 0 {
                            self.eventBodyTextView.text = "Identity: \(name)"
                            Analytics.identify(name)
                        } else {
                            self.eventNameLabel.text = ""
                            self.eventBodyTextView.text = ""
                        }
                    })
                case 1:
                    self.promptForIdentity(completion: {(name) in
                        if let name = name, name.count > 0 {
                            self.eventBodyTextView.text = "Alias: \(name)"
                            Analytics.alias(name)
                        } else {
                            self.eventNameLabel.text = ""
                            self.eventBodyTextView.text = ""
                        }
                    })
                case 2:
                    self.eventBodyTextView.text = "Reset"
                    Analytics.reset()
                case 3:
                    self.trackSegmentEvent()
                case 4:
                    let name = "Segment Screen Test"
                    self.eventBodyTextView.text = "Screen: \(name)"
                    Analytics.screen(name)
                default:
                    break
                }
                self.menuView = nil
            }
        )
        self.menuView?.font = UIFont.systemFont(ofSize: 14.0)
        self.menuView?.textColor = UIColor.darkGray
    }

    func promptForIdentity(completion: ((String?) -> Void)?) {
        if self.keyboardEditor != nil { return }
        self.keyboardEditor = APKeyboardEditor.presentFromViewController(viewController: self, completion: {
            (resultText) in
            completion?(resultText)
            self.keyboardEditor = nil
        })
    }

    func trackSegmentEvent() {
        let keys: [ String ] = Array(AppData.shared.segmentEvents.keys)
        print("Events:\n\(keys)\n.")
        let picker = APArrayPickerView.init(array: keys)
        picker.doneButtonTitle = "Send"
        picker.presentFromViewController(viewController: self, completion: { (selection: String?) in
            self.sendSegmentEvent(selection: selection)
        })
    }

    func selectSegmentEvent(selection: String?) {
        if let selection: String = selection, let body = AppData.shared.segmentEvents[selection]  {
            self.eventNameLabel.text = selection
            self.eventBodyTextView.text = body.description
        } else {
            self.eventNameLabel.text = ""
            self.eventBodyTextView.text = ""
        }
    }

    func sendSegmentEvent(selection: String?) {
        self.selectSegmentEvent(selection: selection)
        if let selection: String = selection, let body = AppData.shared.segmentEvents[selection]  {
            Analytics.track(selection, properties: body as? [String : Any])
        }
    }
}
