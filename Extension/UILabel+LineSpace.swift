//
//  UILabel+LineSpace.swift
//  Weike
//
//  Created by ShenMu on 2017/2/15.
//  Copyright © 2017年 Kuaizai. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setLineSpace(_ lineSpace: CGFloat) {
        var attStr: NSMutableAttributedString
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpace
        if self.attributedText != nil {
            attStr = NSMutableAttributedString(attributedString: self.attributedText!)
            attStr.addAttributes([NSParagraphStyleAttributeName: style], range: NSMakeRange(0, attStr.length))
            self.attributedText = attStr
        } else if self.text != nil {
            attStr = NSMutableAttributedString(string: self.text!)
            attStr.addAttributes([NSParagraphStyleAttributeName: style], range: NSMakeRange(0, attStr.length))
            self.attributedText = attStr
        }
    }
    
}
