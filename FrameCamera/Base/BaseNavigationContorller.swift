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
}
