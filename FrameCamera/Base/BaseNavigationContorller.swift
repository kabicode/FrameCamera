//
//  BaseNavigationContorller.swift
//  PingGuo
//
//  Created by ShenMu on 2017/5/22.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor(hex: 0x1A212B)
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
    }
    
    override var shouldAutorotate: Bool {
        if let shouldAutorotate = self.topViewController?.shouldAutorotate {
            return shouldAutorotate
        }
        return  false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let topViewController = self.topViewController {
            return topViewController.supportedInterfaceOrientations
        }
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
