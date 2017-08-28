//
//  ImageEffectEditVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/2.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit
import MBProgressHUD

class ImageEffectEditVC: BaseViewController {

    enum PGEditBoardType {
        case chartletBoard
        case timeBoard
        case wordBoard
        case paintBoard
    }
    
    enum PGDrawLineWidth: CGFloat {
        case size1      = 5
        case size2      = 7.5
        case size3      = 10
        case size4      = 12.5
    }
    
    @IBOutlet var titleView: UIView!
    
    @IBOutlet weak var myPaster: MyPaster!
    @IBOutlet weak var pasterViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var paintView: DrawingView!
    
    
    // bottomSettingView
    @IBOutlet weak var bottomContentView: UIView!
    
    // Paster
    @IBOutlet weak var pasterCollectionView: UICollectionView!
    
    // Time
    @IBOutlet var timeBoardView: UIView!
    @IBOutlet weak var timeSliderView: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    var minDuration: TimeInterval = 0.1
    var maxDuration: TimeInterval = 5.0
    
    // Word
    @IBOutlet var wordBoardView: UIView!
    @IBOutlet weak var wordColorCollectionView: UICollectionView!
    var alert: UIAlertController!
    var wordColorIndex: Int = 0
    
    // Paint
    @IBOutlet var paintBoardView: UIView!
    @IBOutlet weak var paintColorCollectionView: UICollectionView!
    @IBOutlet weak var paintSize1Btn: UIButton!
    @IBOutlet weak var paintSize2Btn: UIButton!
    @IBOutlet weak var paintSize3Btn: UIButton!
    @IBOutlet weak var paintSize4Btn: UIButton!
    
    var paintColorIndex: Int = 0
    var paintLineSize: PGDrawLineWidth = .size1
    
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
    var pasters: [Paster] = []
    var pasterUrls: [String] = []
    
    
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
        
        defaultSetup()
        
        setupSubviews()
        
        loadData()
    }
    
    func registerCells() {
        registerPasterCollectionCells()
        
        wordColorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        paintColorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }
    
    
    func defaultSetup() {
//        pasters = NSMutableArray(array: pgImage.pasters) as! [Paster]
    }
    
    
    func setupSubviews() {
        
        configurePasterView()
        loadPastersFormPGImage()
        
        navigationItem.titleView = titleView
        titleView.isHidden = true
        
        let leftBarItem = UIBarButtonItem.init(image: UIImage(named: "barBack_white_icon"), style: .plain, target: self, action: #selector(tapBackBarButton))
        navigationItem.leftBarButtonItem = leftBarItem
        
        let rightItem = UIBarButtonItem.init(image: UIImage(named: "done_black_barbutton")?.withRenderingMode(.alwaysOriginal),
                                             style: .plain,
                                             target: self,
                                             action: #selector(tapDoneBarButton))
        navigationItem.rightBarButtonItem = rightItem
        
        selectedBoardType(editBoardType)
    }

    // MARK: - bar Event
    func tapBackBarButton() {
        let alert = UIAlertController.alert(title: "确认退出？",
                                            message: "退出将丢失一部分改动，确认退出吗",
                                            canCancel: true, cancelTitle: "取消",
                                            actionTitle: "确定")
        { [weak self] (action) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func tapDoneBarButton() {
        pgImage.pasters = pasters
        
        if editBoardType == .paintBoard {
            compoundPaintImage()
        }
        
        saveEffectImageToPgImage()
        
        myPaster.saveAllPasterParameters()
        
        PGUserDefault.updateAsset(asset)
        
        navigationController?.popViewController(animated: true)
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
        let request = Router.Chartlet.getChartletList
        NetworkHelper.sendNetworkRequest(request: request,
                                         showHUD: true,
                                         hudTip: nil,
                                         showError: true,
                                         on: self,
                                         successHandler:
            { (json) in
                printLog("\(json)")
                let jsonsArr = json["Data"].arrayValue
                
                self.pasterUrls.removeAll()
                jsonsArr.forEach({ (json) in
                    self.pasterUrls.append(json["Url"].stringValue)
                })
                
                self.pasterCollectionView.reloadData()
                
        }, failureHandler: nil)
        
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
        
        titleView.isHidden = !(type == .paintBoard)
    }
    
    @IBAction func tapUndoButton(_ sender: Any) {
        paintView.undo()
    }
    
    // MARK: - Getter
    var colorMap: [UIColor] {
        return [UIColor.black, UIColor.darkGray, UIColor.gray,
                UIColor.lightGray, UIColor.white, UIColor.red,
                UIColor.green, UIColor.blue, UIColor.yellow,
                UIColor.cyan, UIColor.magenta]
    }
}

// MARK: - Time Board View
extension ImageEffectEditVC {
    
    func addTimeSettingView() {
        wordBoardView.removeFromSuperview()
        paintBoardView.removeFromSuperview()
        
        bottomContentView.addSubview(timeBoardView)
        timeBoardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        configureTimeBoardView()
    }
    
    func configureTimeBoardView() {
        timeSliderView.value = Float((pgImage.duration - minDuration) / (maxDuration - minDuration))
        timeLabel.text = timeBoardDurationText(pgImage.duration)
    }
    
    func saveTimeDuration() {
        pgImage.duration = TimeInterval(timeSliderView.value) * (maxDuration - minDuration) + minDuration
    }
    
    func timeBoardDurationText(_ duration: TimeInterval) -> String {
        return String(format: "时长：%.1fs", duration)
    }
    
    @IBAction func timeSliderDidChange(_ sender: Any) {
        let duration = TimeInterval(timeSliderView.value) * (maxDuration - minDuration) + minDuration
        timeLabel.text = timeBoardDurationText(duration)
    }
    
    @IBAction func closeTimeBoard(_ sender: Any) {
        timeBoardView.removeFromSuperview()
        
        editBoardType = .chartletBoard
        selectedBoardType(editBoardType)
    }
    
    @IBAction func completeTimeBoard(_ sender: Any) {
        saveTimeDuration()
        timeBoardView.removeFromSuperview()
        
        editBoardType = .chartletBoard
        selectedBoardType(editBoardType)
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
            return pasterUrls.count
        }
        
        if collectionView == wordColorCollectionView || collectionView == paintColorCollectionView {
            return colorMap.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.pasterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageAssetPreviewCell", for: indexPath) as! imageAssetPreviewCell
//            cell.imageView.image = UIImage(named: "paster_\(indexPath.row)")
            let urlString = self.pasterUrls[indexPath.row]
            cell.imageView.kf.setImage(with: URL(string: urlString))
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
            if indexPath.row == paintColorIndex {
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
            let urlStirng = pasterUrls[indexPath.row]
            MBProgressHUD.showAdded(to: view, animated: true)
            PGFileHelper.downloadChartlet(urlStirng, compelete: { [weak self] (imagePath, success) in
                guard let strogSelf = self else { return }
                MBProgressHUD.hide(for: strogSelf.view, animated: true)
                
                if let imagePath = imagePath, success {
                    self?.addImagePaster(with: imagePath)
                } else {
                    showMessageNotifiaction("下载贴图失败")
                }
            })
//            let name = "paster_\(indexPath.row)"
//            addImagePaster(with: name)
        }
        
        if collectionView == wordColorCollectionView {
            wordColorIndex = indexPath.row
            wordColorCollectionView.reloadData()
        }
        
        if collectionView == paintColorCollectionView {
            paintColorIndex = indexPath.row
            configurePaintBoardView()
            paintColorCollectionView.reloadData()
        }
    }
}



