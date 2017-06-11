//
//  String+Range.swift
//  Weike
//
//  Created by ShenMu on 2017/1/11.
//  Copyright © 2017年 Kuaizai. All rights reserved.
//

import Foundation

extension String {
    func nsRange(from range: Range<String.Index>?) -> NSRange {
        if range == nil {
            return NSRange(location: 0, length: 0)
        }
        
        let from = range!.lowerBound.samePosition(in: utf16)
        let to = range!.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
}

extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}

extension String {
    func validate(_ regExp: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regExp)
        return predicate.evaluate(with: self)
    }
    
    func validateIntegerNumber() -> Bool {
        return self.validateCharacters(characterSet: "0123456789")
    }
    
    func validateFloatNumber() -> Bool {
        return self.validateCharacters(characterSet: "0123456789.")
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
        guard self.isEmpty == false else {
            return true
        }
        
        let number = self as NSString
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
