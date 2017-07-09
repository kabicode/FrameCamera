//
//  LogHelper.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/10.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import Toaster
import TSMessages


func printLog<T>(_ message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line) {
    
    #if DEBUG
        print("\(NSDate())-\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #else
        let _ = "\(message)" //release状态下 某些情况不调用message会造成swift_unknownRetain奔溃，原因不明。。。orz
    #endif
}

func delay(_ delay: Double, closure: @escaping ()->()) {
    let when = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

// MARK: - Message notification
func showMessageNotifiaction(_ message: String,
                             type: TSMessageNotificationType = .error,
                             on viewController: UIViewController? = nil) {
    
    DispatchQueue.main.async {
        if viewController == nil {
            TSMessage.showNotification(withTitle: message, type: type)
        } else {
            TSMessage.showNotification(in: viewController, title: message, subtitle: "", type: type)
        }
    }
}

// MARK: - Toast
func showToast(_ text: String) {
    DispatchQueue.main.async {
        Toast(text: text).show()
    }
}
