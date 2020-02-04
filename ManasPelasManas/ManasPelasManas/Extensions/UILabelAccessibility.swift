//
//  UILabelAccessibility.swift
//  ManasPelasManas
//
//  Created by Beatriz Viseu Linhares on 04/02/20.
//  Copyright © 2020 Luma Gabino Vasconcelos. All rights reserved.
//

import UIKit

extension UILabel {

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

    var dynamicFont: UIFont {
        set {

            self.numberOfLines = 0

             if #available(iOS 10.0, *) {
                // Real-time size update
                self.adjustsFontForContentSizeCategory = true
             }

            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            self.font = fontMetrics.scaledFont(for: newValue)
        }

        get {
            return self.font
        }
    }
}
