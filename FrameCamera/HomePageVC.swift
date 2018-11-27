//
//  HomePageVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/14.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class HomePageVC: BaseViewController {

    // MARK: - Life Cycle
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
        
        let vc = CreateSnapShotViewController.presentFrom(self, with: asset)
        vc.dismissBlock = { [weak self] in
            let editVC = ImageAssetEditVC()
            editVC.asset = asset
            self?.navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
    @IBAction func tapPhotoLibraryButton(_ sender: Any) {
    }
    
    @IBAction func tapGuideButton(_ sender: Any) {
        let vc = UsingTutorialVC.loadFromStoryboard()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapAboutButton(_ sender: Any) {
        let vc = ProfileViewController.loadFromStoryboard()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
