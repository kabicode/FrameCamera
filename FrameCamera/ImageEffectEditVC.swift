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
    
    
    @IBOutlet weak var myPaster: MyPaster!
    @IBOutlet weak var pasterViewHeightConstraint: NSLayoutConstraint!
    
    // bottomSettingView
    @IBOutlet weak var bottomContentView: UIView!
    
    // Paster
    @IBOutlet weak var pasterCollectionView: UICollectionView!
    
    // Time
    @IBOutlet var timeBoardView: UIView!
    @IBOutlet weak var timeSliderView: UISlider!
    
    // Word
    @IBOutlet var wordBoardView: UIView!
    @IBOutlet weak var wordColorCollectionView: UICollectionView!
    
    var wordColorIndex: Int = 0
    
    // Paint
    @IBOutlet var paintBoardView: UIView!
    @IBOutlet weak var paintColorCollectionView: UICollectionView!
    @IBOutlet weak var paintSize1Btn: UIButton!
    @IBOutlet weak var paintSize2Btn: UIButton!
    @IBOutlet weak var paintSize3Btn: UIButton!
    @IBOutlet weak var paintSize4Btn: UIButton!
    
    var paintColorIndex: Int = 0
    
    
    // bottom buttons
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
    
    var asset: PGAsset!
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
        
        loadData()
    }
    
    func registerCells() {
        registerPasterCollectionCells()
        
        wordColorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        paintColorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }
    
    
    func setupSubviews() {
        
        configurePasterView()
        loadPastersFormPGImage()
        
    }

    
    // MARK: - Actions
    @IBAction func tapChartletButton(_ sender: Any) {
        if editBoardType == .chartletBoard {
            return
        }
        editBoardType = .chartletBoard
        selectedBoardType(editBoardType)
    }
    
    @IBAction func tapTimeEditButton(_ sender: Any) {
        if editBoardType == .timeBoard {
            return
        }
        editBoardType = .timeBoard
        selectedBoardType(editBoardType)
    }
    
    @IBAction func tapWordButton(_ sender: Any) {
        if editBoardType == .wordBoard {
            return
        }
        editBoardType = .wordBoard
        selectedBoardType(editBoardType)
    }
    
    @IBAction func tapPaintButton(_ sender: Any) {
        if editBoardType == .paintBoard {
            return
        }
        editBoardType = .paintBoard
        selectedBoardType(editBoardType)
    }
    
    // MARK: - NetWork
    func loadData() {
        // TODO
        pasterCollectionView.reloadData()
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
        
        switch type {
        case .chartletBoard:
            addChartletSettingView()
        case .timeBoard:
            addTimeSettingView()
        case .wordBoard:
            addWordSettingView()
        case .paintBoard:
            addPaintSettingView()
        }
    }
    
    func addChartletSettingView() {
        
        configureChartleBoardView()
    }
    
    func addTimeSettingView() {
        wordBoardView.removeFromSuperview()
        paintBoardView.removeFromSuperview()
        
        bottomContentView.addSubview(timeBoardView)
        timeBoardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        configureTimeBoardView()
    }
    
    func addWordSettingView() {
        timeBoardView.removeFromSuperview()
        paintBoardView.removeFromSuperview()
        
        bottomContentView.addSubview(wordBoardView)
        wordBoardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        configureWordBoardView()
    }
    
    func addPaintSettingView() {
        timeBoardView.removeFromSuperview()
        wordBoardView.removeFromSuperview()
        
        bottomContentView.addSubview(paintBoardView)
        paintBoardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        configurePaintBoardView()
    }
    
    
    // MARK: - BoardView Actions
    
    @IBAction func closeTimeBoard(_ sender: Any) {
        timeBoardView.removeFromSuperview()
    }
    
    @IBAction func completeTimeBoard(_ sender: Any) {
        //TODO
        timeBoardView.removeFromSuperview()
    }
    
    @IBAction func closeWordBoard(_ sender: Any) {
        wordBoardView.removeFromSuperview()
    }
    
    @IBAction func completeWordBoard(_ sender: UIButton) {
        // TODO
        wordBoardView.removeFromSuperview()
    }
    
    @IBAction func clostPaintBoard(_ sender: Any) {
        paintBoardView.removeFromSuperview()
    }
    
    @IBAction func completePaintBoard(_ sender: Any) {
        // TODO
        paintBoardView.removeFromSuperview()
    }
    
    
    
    
    // MARK: - Getter
    var colorMap: [UIColor] {
        return [UIColor.white, UIColor.black, UIColor.yellow, UIColor.green]
    }
}

// MARK: - Time
extension ImageEffectEditVC {
    func configureTimeBoardView() {
        
    }
}


// MARK: - collectionView Delegate
extension ImageEffectEditVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.pasterCollectionView {
            pasterCollectionView.layoutIfNeeded()
            return CGSize.init(width: pasterCollectionView.frame.height, height: pasterCollectionView.frame.height)
        }
        
        if collectionView == wordColorCollectionView || collectionView == paintColorCollectionView {
            return CGSize.init(width: 25.0, height: 27.0)
        }
        
        return CGSize.zero
    }
}

extension ImageEffectEditVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.pasterCollectionView {
            return 5
        }
        
        if collectionView == wordColorCollectionView || collectionView == paintColorCollectionView {
            return colorMap.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.pasterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageAssetPreviewCell", for: indexPath) as! imageAssetPreviewCell
            cell.imageView.image = UIImage(named: "paster_\(indexPath.row)")
            return cell
        }
        
        if collectionView == wordColorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            cell.backgroundColor = colorMap[indexPath.row]
            return cell
        }
        
        if collectionView == paintColorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            cell.backgroundColor = colorMap[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == wordColorCollectionView {
            if indexPath.row == wordColorIndex {
                cell.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                cell.superview?.bringSubview(toFront: cell)
            } else {
                cell.transform = CGAffineTransform.identity
                cell.superview?.sendSubview(toBack: cell)
            }
        }
        
        if collectionView == paintColorCollectionView {
            if indexPath.row == wordColorIndex {
                cell.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                cell.superview?.bringSubview(toFront: cell)
            } else {
                cell.transform = CGAffineTransform.identity
                cell.superview?.sendSubview(toBack: cell)
            }
        }
    }
}

extension ImageEffectEditVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.pasterCollectionView {
            let name = "paster_\(indexPath.row)"
            addImagePaster(with: name)
        }
        
        if collectionView == wordColorCollectionView {
            wordColorIndex = indexPath.row
            wordColorCollectionView.reloadData()
        }
        
        if collectionView == paintColorCollectionView {
            paintColorIndex = indexPath.row
            paintColorCollectionView.reloadData()
        }
    }
}



