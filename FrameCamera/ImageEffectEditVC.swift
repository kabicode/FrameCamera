//
//  ImageEffectEditVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/2.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class ImageEffectEditVC: BaseViewController {

    enum PGEditBoardType {
        case chartletBoard
        case timeBoard
        case wordBoard
        case paintBoard
    }
    
    @IBOutlet weak var chartletImageView: UIImageView!
    @IBOutlet weak var chartletTitleLabel: UILabel!
    
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeTitleLabel: UILabel!
    
    @IBOutlet weak var wordImageView: UIImageView!
    @IBOutlet weak var wordTitleLabel: UILabel!
    
    @IBOutlet weak var paintImageView: UIImageView!
    @IBOutlet weak var paintTitleLabel: UILabel!
    
    
    // 编辑面板
    var editBoardType: PGEditBoardType = .chartletBoard
    
    var pgImage: PGImage!
    
    
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "ImageEffectEditVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        setupSubviews()
        
        selectedBoardType(editBoardType)
        
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

    
    // MARK: - Actions
    @IBAction func tapChartletButton(_ sender: Any) {
        editBoardType = .chartletBoard
        selectedBoardType(editBoardType)
    }
    
    @IBAction func tapTimeEditButton(_ sender: Any) {
        editBoardType = .timeBoard
        selectedBoardType(editBoardType)
    }
    
    @IBAction func tapWordButton(_ sender: Any) {
        editBoardType = .wordBoard
        selectedBoardType(editBoardType)
    }
    
    @IBAction func tapPaintButton(_ sender: Any) {
        editBoardType = .paintBoard
        selectedBoardType(editBoardType)
    }
    
    // MARK: - Private Method
    func selectedBoardType(_ type: PGEditBoardType) {
        var imageName: String = (type == .chartletBoard) ? "chartlet_highlight": "chartlet_default"
        var titleColor: UIColor = (type == .chartletBoard) ? UIColor.yellowTheme: UIColor.white
        chartletImageView.image = UIImage(named: imageName)
        chartletTitleLabel.textColor = titleColor
        
        imageName = (type == .timeBoard) ? "timeEdit_highlight": "timeEdit_default"
        titleColor = (type == .timeBoard) ? UIColor.yellowTheme: UIColor.white
        timeImageView.image = UIImage(named: imageName)
        timeTitleLabel.textColor = titleColor
        
        imageName = (type == .wordBoard) ? "word_highlight": "word_default"
        titleColor = (type == .wordBoard) ? UIColor.yellowTheme: UIColor.white
        wordImageView.image = UIImage(named: imageName)
        wordTitleLabel.textColor = titleColor
        
        imageName = (type == .paintBoard) ? "paint_highlight": "paint_default"
        titleColor = (type == .paintBoard) ? UIColor.yellowTheme: UIColor.white
        paintImageView.image = UIImage(named: imageName)
        paintTitleLabel.textColor = titleColor
    }
    

}
