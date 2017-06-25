//
//  ViewController.swift
//  FrameCamera
//
//  Created by ShenMu on 2017/5/16.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapCreateButton(_ sender: Any) {
        let vc = CreateSnapShotViewController()
//        navigationController?.pushViewController(vc, animated: true)
        let nav = BaseNavigationController.init(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        present(nav, animated: true, completion: nil)
    }
}

