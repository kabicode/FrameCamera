//
//  ImageEffectEditVC+Paster.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/4.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import Toaster

extension ImageEffectEditVC {
    
    func addChartletSettingView() {
        configureChartleBoardView()
    }
    
    func configurePasterView() {
        myPaster.layoutIfNeeded()
        pasterViewHeightConstraint.constant = (UIScreen.main.bounds.width - 24.0) / (UIScreen.main.bounds.height / UIScreen.main.bounds.width)
        
        myPaster.backgroundColor = UIColor.clear
        myPaster.deleteIcon = UIImage.init(named: "paster_delete")
        myPaster.sizeIcon = UIImage.init(named: "paster_rotate")
        myPaster.rotateIcon = UIImage.init(named: "paster_mirror")
        myPaster.originImage = pgImage.originImage
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
        
        if !pasters.contains(paster) {
            myPaster.add(paster)
            pasters.append(paster)
        } else {
            myPaster.currentPaster = paster
        }
    }
    
    func addImagePaster(with imageName: String, image: UIImage? = nil) {
        // TODO
        let imagePaster = ImagePaster()
        imagePaster.imageName = imageName
        
        imagePaster.image = image ?? UIImage(named: imageName)
        addPaster(imagePaster)
    }

    
    func saveEffectImageToPgImage() {
        let imagePath = (pgImage.effectImagePath == nil) ? PGFileHelper.generateImageFileName(at: asset.filePath): pgImage.effectImagePath!
        if let effectImage = myPaster.getImage() {
            if PGFileHelper.storeImage(effectImage, to: imagePath) {
                pgImage.effectImagePath = imagePath
            }
        }
    }
}

// MARK: - TextPaster
extension ImageEffectEditVC {
    
    func addWordSettingView() {
        timeBoardView.removeFromSuperview()
        paintBoardView.removeFromSuperview()
        
        bottomContentView.addSubview(wordBoardView)
        wordBoardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        configureWordBoardView()
    }
    
    
    func addTextPaster(with text: String) {
        let textPaster = TextPaster()
        textPaster.textColor = colorMap[wordColorIndex]
        textPaster.text = text
        addPaster(textPaster)
    }
    
    
    @IBAction func closeWordBoard(_ sender: Any) {
        wordBoardView.removeFromSuperview()
        editBoardType = .chartletBoard
        selectedBoardType(editBoardType)
    }
    
    @IBAction func completeWordBoard(_ sender: UIButton) {
        // TODO
        wordBoardView.removeFromSuperview()
        
        alert = UIAlertController.alert(title: "请输入贴图文字", message: nil, canCancel: true, cancelTitle: "取消", actionTitle: "确定") { [weak self] (action) in
            if let textField = self?.alert.textFields?.first {
                guard let text = textField.text, text.characters.count > 0 else {
                    showMessageNotifiaction("输入内容不能为空", on: self)
                    return
                }
                self?.addTextPaster(with: text)
            }
        }
        alert.addTextField { [weak self] (textField) in
            guard let strongSelf = self else {
                return
            }
            
            let color = strongSelf.colorMap[strongSelf.wordColorIndex]
            textField.backgroundColor = (color == UIColor.white) ? UIColor.black: UIColor.white
            textField.textColor = color
        }
        present(alert, animated: true, completion: nil)
        
        
        editBoardType = .chartletBoard
        selectedBoardType(editBoardType)
    }
}


// MARK: - PasterDelegate
extension ImageEffectEditVC: MyPasterDelegate {
    
    func myPaster(_ myPaster: MyPaster!, pasterIsSelect paster: Paster!) {
        if let index = pasters.index(of: paster) {
            pasters.remove(at: index)
            pasters.append(paster)
        }
    }
    

    
    func myPaster(_ myPaster: MyPaster!, delete paster: Paster!) {
        if let index = pasters.index(of: paster) {
            pasters.remove(at: index)
//            saveImagePasters()
        }
    }
}
