//
//  TextFieldManager.swift
//  ManasPelasManas
//
//  Created by Joyce Simão Clímaco on 27/08/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import Foundation
import UIKit

protocol TextFieldManagerDelegate: AnyObject {
    func setFieldToDatePickerToolbar(textField: UITextField)
}

class TextFieldManager: NSObject, UITextFieldDelegate {
    
    weak var delegate: TextFieldManagerDelegate?

    //swiftlint:disable identifier_name
    func textFieldSetup(textField: UITextField, tag: Int) {
        // Creates Identifier
        textField.tag = tag

        // Visual Design for TextField
        textField.text = ""
        textField.tintColor = .clear
        textField.borderStyle = .none
        
        guard let delegate = self.delegate else {
            print("Fail: Text Field Manager Delegate not defined")
            return
        }
        delegate.setFieldToDatePickerToolbar(textField: textField)
    }
    
}
