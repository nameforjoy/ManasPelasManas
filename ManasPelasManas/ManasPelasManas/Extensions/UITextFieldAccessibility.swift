//
//  UITextFieldAccessibility.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 10/02/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

extension UITextField {

    @IBInspectable var dynamicTheme: String {
        get {
            return self.dynamicTheme
        }
        set {
            let fontName = newValue.components(separatedBy: "_")[0]
            let fontSize = CGFloat(Int(newValue.components(separatedBy: "_")[1]) ?? 17)

            let newFont = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
            self.dynamicFont = newFont
        }
    }

    var dynamicFont: UIFont {
        get {
            return self.font ?? UIFont()
        }
        set {
            self.textAlignment = .center

             if #available(iOS 10.0, *) {
                // Real-time size update
                self.adjustsFontForContentSizeCategory = true
             }

            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            self.font = fontMetrics.scaledFont(for: newValue)
        }
    }
}
