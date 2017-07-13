//
//  HomePageVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/14.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class HomePageVC: BaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    @IBAction func tapCameraButton(_ sender: Any) {
        let asset = PGAsset(filePath: PGFileHelper.generateImageAssetFilePath())
        PGUserDefault.addAsset(asset)
        
        let _ = CreateSnapShotViewController.presentFrom(self, with: asset)
    }
    
    @IBAction func tapPhotoLibraryButton(_ sender: Any) {
    }
    
    @IBAction func tapGuideButton(_ sender: Any) {
    }
    
    @IBAction func tapAboutButton(_ sender: Any) {
    }
    
}
