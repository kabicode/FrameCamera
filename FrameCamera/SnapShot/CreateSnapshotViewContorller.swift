//
//  CreateSnapshotViewContorller.swift
//  PingGuo
//
//  Created by ShenMu on 2017/5/22.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import UIKit

class CreateSnapShotViewController: BaseViewController {
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeOrientation(to: .landscapeLeft)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
    }
}
