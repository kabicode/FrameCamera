//
//  ImageEffectEditVC+Paint.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/5.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation

extension ImageEffectEditVC {
    func setupPaintBoardView() {
        paintColorCollectionView.dataSource = self
        paintColorCollectionView.delegate = self
        
        paintView.isHidden = false
        paintView.clear()
        
        configurePaintBoardView()
    }
    
    func compoundPaintImage() {
        let result = paintView.getImage()
        if let image = result.image, result.changed == true {
            let size = myPaster.originImage.size
            UIGraphicsBeginImageContext(size)
            myPaster.originImage.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
            image.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
            
            let compoundImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            guard compoundImage != nil else {
                return
            }
            
            if PGFileHelper.storeImage(compoundImage!, to: pgImage.imagePath) {
                configurePasterView()
            }
        }
    }
    
    func configurePaintBoardView() {
        paintView.lineWidth = paintLineSize.rawValue
        paintView.lineColor = colorMap[paintColorIndex]
        
        paintSize1Btn.isSelected = (paintLineSize == .size1)
        paintSize2Btn.isSelected = (paintLineSize == .size2)
        paintSize3Btn.isSelected = (paintLineSize == .size3)
        paintSize4Btn.isSelected = (paintLineSize == .size4)
    }
    
    
    func addPaintSettingView() {
        timeBoardView.removeFromSuperview()
        wordBoardView.removeFromSuperview()
        
        bottomContentView.addSubview(paintBoardView)
        paintBoardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        myPaster.saveAllPasterParameters()
        setupPaintBoardView()
    }
    
    // MARK: - Actions
    @IBAction func tapSize1Btn(_ sender: Any) {
        paintLineSize = .size1
        configurePaintBoardView()
    }
    
    @IBAction func tapSize2Btn(_ sender: Any) {
        paintLineSize = .size2
        configurePaintBoardView()
    }
    
    @IBAction func tapSize3Btn(_ sender: Any) {
        paintLineSize = .size3
        configurePaintBoardView()
    }
    
    @IBAction func tapSize4Btn(_ sender: Any) {
        paintLineSize = .size4
        configurePaintBoardView()
    }
    
    
    @IBAction func clostPaintBoard(_ sender: Any) {
        paintBoardView.removeFromSuperview()
        paintView.isHidden = true;
        
        editBoardType = .chartletBoard
        selectedBoardType(editBoardType)
    }
    
    @IBAction func completePaintBoard(_ sender: Any) {
        // TODO
        compoundPaintImage()
        paintView.isHidden = true;
        paintBoardView.removeFromSuperview()
        
        editBoardType = .chartletBoard
        selectedBoardType(editBoardType)
    }
}
