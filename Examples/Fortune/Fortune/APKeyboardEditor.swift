//
//  APKeyboardEditor.swift
//  Fortune
//
//  Created by Edward on 2/13/18.
//  Copyright © 2018 Branch. All rights reserved.
//

import UIKit

func APInstanceFromNib(named: String, classX: AnyClass) -> AnyObject? {
    if let objects = Bundle.main.loadNibNamed(named, owner: nil, options: nil) as [AnyObject]? {
        for object in objects {
            if object.isKind(of: classX) {
                return object
            }
        }
    }
    return nil
}

class APKeyboardEditor: UIView, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var parentViewController: UIViewController?

    var completionBlock: ((String?) -> Void)?

    private
    var dummyTextField: UITextField?
    var isDone: Bool = false

    class func presentFromViewController(
        viewController: UIViewController,
        completion: ((String?) -> Void)?
    ) -> APKeyboardEditor? {

        guard let keyboardEditor: APKeyboardEditor =
            APInstanceFromNib(named: "APKeyboardEditor", classX: APKeyboardEditor.self) as? APKeyboardEditor
        else { return nil }

        keyboardEditor.completionBlock = completion
        keyboardEditor.presentFrom(viewController: viewController)
        return keyboardEditor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func presentFrom(viewController: UIViewController) {
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.15).cgColor
        self.layer.borderWidth = 0.50

        let textField = UITextField.init(frame: CGRect.zero)
        self.parentViewController = viewController
        self.parentViewController?.view.addSubview(textField)
        textField.inputAccessoryView = self
        textField.becomeFirstResponder()
        self.dummyTextField = textField

        self.textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.10).cgColor
        self.textField.layer.borderWidth = 2.00
        self.textField.layer.cornerRadius = 2.0
        self.textField.layer.sublayerTransform = CATransform3DMakeTranslation(7.0, 0, 0);
        self.textField.delegate = self

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            self.textField.becomeFirstResponder()
        }

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if (self.isDone) { return }
        self.isDone = true

        self.dummyTextField?.endEditing(true)
        self.dummyTextField?.inputAccessoryView = nil

        self.textField.endEditing(true)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)

        self.completionBlock?(self.textField.text)
        self.completionBlock = nil
        self.parentViewController = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            self.dummyTextField?.removeFromSuperview()
            self.dummyTextField = nil
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }

    @IBAction func doneAction(sender: Any) {
        self.dismissKeyboard()
    }

    func dismissKeyboard() {
        self.textField.endEditing(true)
        self.dummyTextField?.endEditing(true)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}
