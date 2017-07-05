//
//  AudioEffectEditVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/6.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class AudioEffectEditVC: BaseViewController {

    @IBOutlet weak var tabBar: UITabBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.delegate = self
    }

    
    

}

extension AudioEffectEditVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "音乐库" {
            
        } else if item.title == "录音" {
            
        }
    }
}
