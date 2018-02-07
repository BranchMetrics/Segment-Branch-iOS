//
//  ArrayPickerView.swift
//  Fortune
//
//  Created by Edward on 2/5/18.
//  Copyright © 2018 Branch. All rights reserved.
//

import UIKit

class ArrayPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    private
    var pickerArray: [String] = []
    var dummyTextField: UITextField?
    var completionBlock: ((String?) -> Void)?

    public
    var doneButtonTitle: String?
    var selectChangedBlock: ((String?) -> Void)?

    init(array: [String]) {
        super.init(frame: CGRect.zero)
        self.pickerArray = array
        self.delegate = self
        self.dataSource = self
        self.doneButtonTitle = "Done"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func presentFromViewController(viewController: UIViewController, completion: ((String?) -> Void)?) {
        self.completionBlock = completion
        let toolBar = UIToolbar.init(frame:CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar.items = [
            UIBarButtonItem.init(title:"Cancel", style:.plain, target:self, action:#selector(cancelAction)),
            UIBarButtonItem.init(barButtonSystemItem:.flexibleSpace, target:nil, action:nil),
            UIBarButtonItem.init(title:self.doneButtonTitle, style:.done, target:self, action:#selector(doneAction))
        ];
        let textField = UITextField.init(frame: CGRect.zero)
        viewController.view.addSubview(textField)
        textField.inputView = self
        textField.inputAccessoryView = toolBar
        textField.becomeFirstResponder()
        self.dummyTextField = textField
    }

    // MARK: - Done Actions

    @objc func cancelAction(sender: Any) {
        self.dismiss(index:-1)
    }

    @objc func doneAction(sender: Any) {
        self.dismiss(index:self.selectedRow(inComponent:0))
    }

    func dismiss(index: Int) {
        var selection: String?
        if (index >= 0) { selection = self.pickerArray[index] }
        if let completion = self.completionBlock {
            completion(selection)
        }
        self.dummyTextField?.removeFromSuperview()
        self.dummyTextField = nil;
    }

    // MARK: - Picker View Delegates

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerArray.count;
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerArray[row];
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let changedBlock = self.selectChangedBlock {
            var selection: String?
            if (row >= 0) { selection = self.pickerArray[row] }
            changedBlock(selection)
        }
    }
}
