//
//  UIColor+Ext.swift
//  ChatApp
//
//  Created by Roman Khodukin on 2/21/21.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        // Check for hash and remove the hash
        let cleanedHexString = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        // String -> UInt32
        var rgbValue = UInt32()
        Scanner(string: cleanedHexString).scanHexInt32(&rgbValue)
        
        // UInt32 -> R,G,B
        let a, r, g, b: UInt32
        
        switch cleanedHexString.count {
        case 3: // RGB (12-bit)
            (r, g, b) = (
                (rgbValue >> 8) * 17,
                (rgbValue >> 4 & 0xF) * 17,
                (rgbValue & 0xF) * 17
            )
            
            self.init(
                red: CGFloat(r) / 255,
                green: CGFloat(g) / 255,
                blue: CGFloat(b) / 255,
                alpha: alpha
            )
        case 6: // RGB (24-bit)
            (r, g, b) = (
                rgbValue >> 16,
                rgbValue >> 8 & 0xFF,
                rgbValue & 0xFF
            )
            
            self.init(
                red: CGFloat(r) / 255,
                green: CGFloat(g) / 255,
                blue: CGFloat(b) / 255,
                alpha: alpha
            )
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (
                rgbValue >> 24,
                rgbValue >> 16 & 0xFF,
                rgbValue >> 8 & 0xFF,
                rgbValue & 0xFF
            )
            
            self.init(
                red: CGFloat(r) / 255,
                green: CGFloat(g) / 255,
                blue: CGFloat(b) / 255,
                alpha: CGFloat(a) / 255
            )
        default:
            self.init(white: 1, alpha: alpha)
        }
    }
}
