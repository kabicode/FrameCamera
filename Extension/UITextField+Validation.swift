//
//  UITextField+Validation.swift
//  Weike
//
//  Created by yake on 2016/10/14.
//  Copyright © 2016年 Kuaizai. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    var isEmpty: Bool {
        return self.text == nil || self.text!.isEmpty
    }
    
    func validate(_ regExp: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regExp)
        return predicate.evaluate(with: self.text)
    }
    
    func validateIntegerNumber() -> Bool {
        return self.validate("^\\d+$")
    }
    
    func validateFloatNumber() -> Bool {
        return self.validate("^\\d+.?(\\d+)?$")
    }
    
    func validatePhoneNumber() -> Bool {
        return self.validate("^\\d{5,}$")
    }
    
    func validateVerificationCode() -> Bool {
        return self.validate("^\\d{4}$")
    }
    
    // characterSet: eg. "0123456789" "0123456789."
    func validateCharacters(characterSet: String) -> Bool {
        let tmpSet = CharacterSet.init(charactersIn: characterSet)
        guard let text = self.text, text.isEmpty == false else {
            return true
        }
        
        let number = text as NSString
        var i = 0
        while (i < number.length) {
            let str = number.substring(with: NSMakeRange(i, 1))
            let range = str.rangeOfCharacter(from: tmpSet)
            if range == nil {
                return false
            }
            i = i + 1
        }
        return true
    }
}
