//
//  ImageEffectEditVC+Paster.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/4.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation

extension ImageEffectEditVC {
    
    func configurePasterView() {
        myPaster.layoutIfNeeded()
        pasterViewHeightConstraint.constant = myPaster.frame.width / (UIScreen.main.bounds.height / UIScreen.main.bounds.width)
        
        myPaster.backgroundColor = UIColor.clear
        myPaster.deleteIcon = UIImage.init(named: "paster_delete")
        myPaster.sizeIcon = UIImage.init(named: "paster_rotate")
        myPaster.rotateIcon = UIImage.init(named: "paster_mirror")
        myPaster.originImage = UIImage(contentsOfFile: pgImage.sandboxPath)
        myPaster.delegate = self
    }
    
    func configureChartleBoardView() {
        pasterCollectionView.dataSource = self;
        pasterCollectionView.delegate = self;
        pasterCollectionView.contentInset = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func configureWordBoardView() {
        wordColorCollectionView.dataSource = self
        wordColorCollectionView.delegate = self
    }
    
    func registerPasterCollectionCells() {
        pasterCollectionView.register(UINib.init(nibName: "imageAssetPreviewCell", bundle: nil), forCellWithReuseIdentifier: "imageAssetPreviewCell")
    }
    
    func loadPastersFormPGImage() {
        for paster in pgImage.pasters {
            addPaster(paster)
        }
    }
    
    // MARK: - Add Paster
    func addPaster(_ paster: Paster) {
        
        if !pgImage.pasters.contains(paster) {
            myPaster.add(paster)
            pgImage.pasters.append(paster)
        } else {
            myPaster.currentPaster = paster
        }
    }
    
    func addImagePaster(with imageName: String) {
        // TODO
        let imagePaster = ImagePaster()
        imagePaster.imageName = imageName
        
        imagePaster.image = UIImage(named: imageName)
        addPaster(imagePaster)
    }

    func addTextPaster(with text: String) {
        // TODO
        let textPaster = TextPaster()
        addPaster(textPaster)
    }
    
    func saveImagePasters() -> UIImage {
        // TODO
        myPaster.saveAllPasterParameters()
        return myPaster.pasterImage
    }
    
}

extension ImageEffectEditVC: MyPasterDelegate {
    
    func myPaster(_ myPaster: MyPaster!, pasterIsSelect paster: Paster!) {
        if let index = pgImage.pasters.index(of: paster) {
            pgImage.pasters.remove(at: index)
            pgImage.pasters.append(paster)
//            saveImagePasters()
        }
    }
    

    
    func myPaster(_ myPaster: MyPaster!, delete paster: Paster!) {
        if let index = pgImage.pasters.index(of: paster) {
            pgImage.pasters.remove(at: index)
//            saveImagePasters()
        }
    }
}
