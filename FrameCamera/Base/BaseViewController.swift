//
//  BaseViewController.swift
//  PingGuo
//
//  Created by ShenMu on 2017/5/22.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !shouldAutorotate {
            changeOrientation(to: .portrait)
        }
    }
    
    func changeOrientation(to orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue( NSNumber(value: UIInterfaceOrientation.unknown.rawValue) , forKey: "orientation")
        UIDevice.current.setValue(NSNumber(value: orientation.rawValue), forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}
