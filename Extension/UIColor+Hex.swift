//
//  UIColor+Hex.swift
//  Weike
//
//  Created by yake on 2016/10/7.
//  Copyright © 2016年 Kuaizai. All rights reserved.
//

import Foundation

extension UIColor {
    convenience init(hex: Int) {
        let redHex = (hex >> 16) & 0xff
        let greenHex = (hex >> 8) & 0xff
        let blueHex = hex & 0xff
        
        let red = CGFloat(redHex) / 255.0
        let green = CGFloat(greenHex) / 255.0
        let blue = CGFloat(blueHex) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

// MARK: - Custom color
extension UIColor {
    static var lycheerGreen: UIColor {
        return UIColor(hex: 0x09BB07)
    }
    
    static var lycheerOrange: UIColor {
        return UIColor(hex: 0xFFBC00)
    }
    
    static var lycheerLightGray: UIColor {
        return UIColor(hex: 0xEFEFF4)
    }
    
    static var lycheerRed: UIColor {
        return UIColor(hex: 0xFF5341)
    }
    
}
