//
//  PGShareViewController.swift
//  PingGuo
//
//  Created by ShenMu on 2017/8/3.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class PGShareViewController: BaseViewController {
    
    @IBOutlet weak var wechatShareBtn: UIButton!
    @IBOutlet weak var qqShareBtn: UIButton!
    @IBOutlet weak var sinaShareBtn: UIButton!
    
    static func loadFromStoryboard() -> PGShareViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PGShareViewController") as! PGShareViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tapWechatShare(_ sender: Any) {
    }
    
    @IBAction func tapQQShare(_ sender: Any) {
    }
    
    @IBAction func tapSinaShare(_ sender: Any) {
    }
    
}
