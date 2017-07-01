//
//  ImageEffectEditVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/2.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class ImageEffectEditVC: BaseViewController {

    // MARK: - Life Cycle
    init() {
        super.init(nibName: "ImageAssetEditVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupSubviews()
//        collectionView.reloadData()
//        
//        if asset.imageList.count > 0 {
//            selectedIndex = 0
//            selectedImageItem(at: 0)
//        }
    }
    
    func registerCells() {
//        collectionView.register(UINib.init(nibName: "imageAssetPreviewCell", bundle: nil), forCellWithReuseIdentifier: "imageAssetPreviewCell")
    }
    
    func setupSubviews() {
//        previewImageView.layoutIfNeeded()
//        previewImageHeightConstraint.constant = previewImageView.frame.width / (UIScreen.main.bounds.height / UIScreen.main.bounds.width)
    }

    

}
