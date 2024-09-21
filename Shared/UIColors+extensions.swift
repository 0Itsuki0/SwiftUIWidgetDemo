//
//  UIColors+extensions.swift
//  WidgetDemo
//
//  Created by Itsuki on 2024/09/18.
//

import SwiftUI

extension UIColor {
    static func rgba(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    var rgba: (Int, Int, Int, Float)? {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a: CGFloat = 0
       
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (Int(r * 255.0), Int(g * 255.0), Int(b * 255.0), Float(a))
        } else {
            return nil
        }
    }
    
    func hex(includeAlpha: Bool = false) -> String? {
        guard let (r, g, b, a) = self.rgba else {
            return nil
        }
        let hexString: String = if includeAlpha {
            String(format: "%02X%02X%02X%02X", r, g, b, Int(a * 255.0))
        } else {
            String(format: "%02X%02X%02X", r, g, b)
        }
        
        return "#\(hexString)"
    }
}
