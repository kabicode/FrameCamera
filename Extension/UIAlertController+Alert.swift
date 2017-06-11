//
//  UIAlertController.swift
//  Weike
//
//  Created by yake on 2017/3/20.
//  Copyright © 2017年 Senji. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func confirmAlert(
        showAt viewController: UIViewController,
        with title: String?,
        message: String? = nil,
        actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: NSLocalizedString("common.ok", comment: "Alert OK"),
            style: .default, handler: { (action) in
                actionHandler?(action)
        })
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func alert(
        title: String?,
        message: String? = nil,
        canCancel: Bool = true,
        cancelTitle: String? = nil,
        actionTitle: String?,
        actionHandler: ((UIAlertAction) -> Void)? = nil)
        -> UIAlertController {
            
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: actionTitle,
            style: .default, handler: { (action) in
                actionHandler?(action)
        })
        alert.addAction(action)
            
        if canCancel {
            let title = cancelTitle ?? NSLocalizedString("common.cancel", comment: "Alert Cancel")
            let cancel = UIAlertAction(
                title: title,
                style: .cancel, handler: nil)
            alert.addAction(cancel)
        }
        return alert
    }
    
    static func okAlert(
        title: String?,
        message: String? = nil,
        canCancel: Bool = false,
        actionHandler: ((UIAlertAction) -> Void)? = nil)
        -> UIAlertController {
            
            return alert(
                title: title,
                message: message,
                canCancel: canCancel,
                actionTitle: NSLocalizedString("common.ok", comment: "OK"),
                actionHandler: actionHandler)
    }
    
    static func deleteAlert(
        title: String?,
        message: String? = nil,
        canCancel: Bool = true,
        actionHandler: ((UIAlertAction) -> Void)? = nil)
        -> UIAlertController {
            
            return alert(
                title: title,
                message: message,
                canCancel: canCancel,
                actionTitle: NSLocalizedString("common.delete", comment: "Delete"),
                actionHandler: actionHandler)
    }
}
