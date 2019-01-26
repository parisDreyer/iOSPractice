//
//  SettingsViewController.swift
//  business-cards
//
//  Created by Luke Dreyer on 1/25/19.
//  Copyright © 2019 LukeDreyer. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class SettingsViewController: UIViewController, UITextFieldDelegate{
    
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        setupTextFields()
    }
    
    // UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("should return is called")
        // User finished typing (hit return): hide the keyboard.
        
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("end is called")
//        print(textField.text!)
        Data.setDefaults(sender: textField)
    }
    
    @objc func setupTextFields(){
        for (idx, field_name) in Data.TextFields.enumerated() {
            let value = Data.getDefault(key: field_name)
            let textField =  UITextField(frame: CGRect(x: 50, y: 100 + idx * 50, width: 300, height: 40))
            textField.placeholder = field_name
            textField.text = value
            textField.font = UIFont.systemFont(ofSize: 22)
            textField.borderStyle = UITextField.BorderStyle.roundedRect
            textField.autocorrectionType = UITextAutocorrectionType.no
            textField.keyboardType = UIKeyboardType.default
            textField.returnKeyType = UIReturnKeyType.done
            textField.enablesReturnKeyAutomatically = true
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            textField.delegate = self
            textField.tag = idx
            self.textFields.append(textField)
            self.view.addSubview(textField)
        }
    }
}
