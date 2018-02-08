//
//  EventViewController.swift
//  Fortune
//
//  Created by Edward on 2/5/18.
//  Copyright © 2018 Branch. All rights reserved.
//

import UIKit
import Analytics

class EventViewController: UIViewController {
    @IBOutlet weak var sendEventButton: UIButton!
    @IBOutlet weak var eventBodyTextView: UITextView!
    @IBOutlet weak var eventNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        sendEventButton.layer.cornerRadius = 5.0
        if let c = self.sendEventButton.titleColor(for: .normal) {
            sendEventButton.layer.borderColor = c.cgColor
            sendEventButton.layer.borderWidth = 0.5
        }
        self.selectSegmentEvent(selection: "")
    }

    @IBAction func sendEventAction(_ sender: Any) {
        self.eventNameLabel.text = ""
        self.eventBodyTextView.text = ""
        let keys: [ String ] = Array(AppData.shared.segmentEvents.keys)
        let picker = ArrayPickerView.init(array: keys)
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
            Analytics?.track(selection, properties: body as? [String : Any])
        }
    }

}
