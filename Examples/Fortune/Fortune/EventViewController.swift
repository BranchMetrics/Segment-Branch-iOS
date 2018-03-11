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
        segmentActionButton.layer.cornerRadius = 5.0
//        if let c = self.segmentActionButton.titleColor(for: .normal) {
//            segmentActionButton.layer.borderColor = c.cgColor
//            segmentActionButton.layer.borderWidth = 0.5
//        }
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
            "Send Branch Event"
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
                case 5:
                    self.eventNameLabel.text = "Send Branch Event"
                    self.sendBranchEvent()
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

    func sendBranchEvent() {
        let buo = BranchUniversalObject.init()

        buo.contentMetadata.contentSchema    = .commerceProduct;
        buo.contentMetadata.quantity         = 2;
        buo.contentMetadata.price            = 23.20
        buo.contentMetadata.currency         = .USD;
        buo.contentMetadata.sku              = "1994320302";
        buo.contentMetadata.productName      = "my_product_name1";
        buo.contentMetadata.productBrand     = "my_prod_Brand1";
        buo.contentMetadata.productCategory  = .babyToddler;
        buo.contentMetadata.productVariant   = "3T";
        buo.contentMetadata.condition        = .fair;

        buo.contentMetadata.ratingAverage    = 5;
        buo.contentMetadata.ratingCount      = 5;
        buo.contentMetadata.ratingMax        = 7;
        buo.contentMetadata.rating           = 6;
        buo.contentMetadata.addressStreet    = "Street_name1";
        buo.contentMetadata.addressCity      = "city1";
        buo.contentMetadata.addressRegion    = "Region1";
        buo.contentMetadata.addressCountry   = "Country1";
        buo.contentMetadata.addressPostalCode = "postal_code";
        buo.contentMetadata.latitude         = 12.07;
        buo.contentMetadata.longitude        = -97.5;
        buo.contentMetadata.imageCaptions    = [ "my_img_caption1", "my_img_caption_2"]
        buo.contentMetadata.customMetadata   = [
            "Custom_Content_metadata_key1": "Custom_Content_metadata_val1",
            "Custom_Content_metadata_key2": "Custom_Content_metadata_val2",
            "~campaign": "Parul's campaign"
        ]
        buo.title                       = "Parul Title";
        buo.canonicalIdentifier         = "item/12345";
        buo.canonicalUrl                = "https://branch.io/deepviews";
        buo.keywords                    = ["My_Keyword1", "My_Keyword2"];
        buo.contentDescription          = "my_product_description1";
        buo.imageUrl                    = "https://test_img_url";
        buo.expirationDate              = Date.init(timeIntervalSinceNow: 24*60*60)
        buo.publiclyIndex               = false
        buo.locallyIndex                = true
        buo.creationDate                = Date.init()

        let event = BranchEvent.standardEvent(.purchase)
        event.transactionID   = "12344555"
        event.currency        = .USD;
        event.revenue         = 1.5
        event.shipping        = 10.2
        event.tax             = 12.3
        event.coupon          = "test_coupon"
        event.affiliation     = "test_affiliation";
        event.eventDescription = "Event _description";
        event.customData      = [
            "Custom_Event_Property_Key1": "Custom_Event_Property_val1",
            "Custom_Event_Property_Key2": "Custom_Event_Property_val2"
        ]
        event.contentItems = [ buo ]
        event.logEvent()
        let dictionary = event.dictionary()
        self.eventBodyTextView.text = dictionary.description
    }
}
