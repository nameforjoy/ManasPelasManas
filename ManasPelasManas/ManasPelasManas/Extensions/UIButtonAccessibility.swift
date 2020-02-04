//
//  UIButtonAccessibility.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 04/02/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

extension UIButton {

    var dynamicFont: UIFont {
        set {
            self.titleLabel?.dynamicFont = newValue

            self.titleLabel?.textAlignment = .center
            self.titleLabel?.lineBreakMode = .byWordWrapping
        }

        get {
            return self.titleLabel?.font ?? UIFont()
        }
    }
}


extension UIButton {

    @IBInspectable var dynamicTheme: String {
        set {
            let fontName = newValue.components(separatedBy: "_")[0]
            let fontSize = CGFloat(Int(newValue.components(separatedBy: "_")[1]) ?? 17)

            let newFont = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
            self.dynamicFont = newFont
        }

        get {
            return self.dynamicTheme
        }
    }

}
