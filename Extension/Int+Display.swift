//
//  Int+Display.swift
//  Weike
//
//  Created by yake on 2016/12/6.
//  Copyright © 2016年 Kuaizai. All rights reserved.
//

import Foundation

let intDisplayFormat = NSLocalizedString("common.intDisplayFormat", comment: "Int display format")

extension Int {
    var display: String {
        if self < 10000 {
            return String(self)
        } else {
            let n = Double(self) / 10000.0
            return String(format: intDisplayFormat, n)
        }
    }
}
