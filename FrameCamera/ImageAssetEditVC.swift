//
//  ImageAssetEditVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/1.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit
import Toaster
import MBProgressHUD

class ImageAssetEditVC: BaseViewController {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var previewImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var deleteImageBtn: UIButton!
    @IBOutlet weak var addImageBtn: UIButton!
    
    
    var asset: PGAsset!
    
    var selectedIndex: Int?
    
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "ImageAssetEditVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.changeOrientation(to: .portrait)
//        collectionView.reloadData()
//    }
    
//    override var shouldAutorotate: Bool {
//        return false
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.changeOrientation(to: .portrait)
//        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        setupSubviews()
        collectionView.reloadData()
        
        if asset.imageList.count > 0 {
            selectedIndex = 0
            selectedImageItem(at: 0)
        }
    }

    func registerCells() {
        collectionView.register(UINib.init(nibName: "imageAssetPreviewCell", bundle: nil), forCellWithReuseIdentifier: "imageAssetPreviewCell")
    }
    
    func setupSubviews() {
        previewImageView.layoutIfNeeded()
        previewImageHeightConstraint.constant = previewImageView.frame.width / (UIScreen.main.bounds.height / UIScreen.main.bounds.width)
    
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.init(hex: 0x606060)
        btn.setTitle("合成", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        btn.frame = CGRect.init(x: 0, y: 0, width: 62.0, height: 19.0)
        btn.layer.cornerRadius = btn.frame.height / 2.0
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(tapNextStepButton), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem.init(customView: btn)
        navigationItem.rightBarButtonItem = rightItem
    }

    // MARK: - Actions
    func tapNextStepButton() {
        generousPreviewVideoAction()
    }
    
    @IBAction func tapLeftButton(_ sender: Any) {
        if let index = selectedIndex, index > 0 {
            selectedIndex = index - 1
            selectedImageItem(at: selectedIndex)
        }
    }

    @IBAction func tapRightButton(_ sender: Any) {
        if let index = selectedIndex, index < asset.imageList.count - 1 {
            selectedIndex = index + 1
            selectedImageItem(at: selectedIndex)
        }
    }
    
    @IBAction func tapDeleteImageButton(_ sender: Any) {
        if let index = selectedIndex, index < asset.imageList.count {
            let image = asset.imageList[index]
            let _ = asset.delete(image)
            selectedIndex = (index < asset.imageList.count) ? index: (index == 0 ? nil: asset.imageList.count - 1)
            
            selectedImageItem(at: selectedIndex)
        }
    }
    
    
    @IBAction func tapAddImageButton(_ sender: Any) {
        let vc = CreateSnapShotViewController.presentFrom(self, with: asset)
        vc.snapshotMode = .singleSnapshotMode
        let imageIndex = (self.selectedIndex != nil) ? self.selectedIndex!: 0
        vc.singleSnapshotDoubleImage = asset.imageList[imageIndex]
        
        vc.singleShotBlock = {[weak self] image in
            guard let strongSelf = self else {return}
            let index = (strongSelf.selectedIndex != nil) ? (strongSelf.selectedIndex)! + 1 : 0
            let _ = strongSelf.asset.add(image, at: index)
            strongSelf.selectedIndex = index
            strongSelf.selectedImageItem(at: index)
        }
    }
    
    
    @IBAction func tapPreviewButton(_ sender: Any) {
//        guard asset.imageList.count > 0 else {
//            showMessageNotifiaction("视频图片为空，请添加图片", on: self)
//            return
//        }
//        
//        MBProgressHUD.showAdded(to: view, animated: true)
//        PGVideoHelper.generousOriginMovie(from: asset) { (fileURL, duration) in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            
//            self.pushToVideoPreviewVC()
//        }
        generousPreviewVideoAction()
    }

    @IBAction func tapSpecialEffecButton(_ sender: Any) {
        guard let selectedIndex = self.selectedIndex, selectedIndex < asset.imageList.count else { return }
        
        let pgImage = asset.imageList[selectedIndex]
        let vc = ImageEffectEditVC()
        vc.asset = asset
        vc.pgImage = pgImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapAudioButton(_ sender: Any) {
        guard asset.imageList.count > 0 else {
            showMessageNotifiaction("视频图片为空，请添加图片", on: self)
            return
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        PGVideoHelper.generousOriginMovie(from: asset) { (fileURL, duration) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            let audioEffectVC = AudioEffectEditVC()
            audioEffectVC.asset = self.asset
            self.navigationController?.pushViewController(audioEffectVC, animated: true)
        }
    }
    
    // Private Method
    func selectedImageItem(at index: Int?) {
        if let selectedIndex = index {
            collectionView(collectionView, didSelectItemAt: IndexPath.init(row: selectedIndex, section: 0))
        } else {
            collectionView.reloadData()
        }
    }
    
    func generousPreviewVideoAction() {
        guard asset.imageList.count > 0 else {
            showMessageNotifiaction("视频图片为空，请添加图片", on: self)
            return
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        PGVideoHelper.generousOriginMovie(from: asset) {[weak self] (fileURL, duration) in
            guard let StrongSelf = self else { return }
            MBProgressHUD.hide(for: StrongSelf.view, animated: true)
            
            MBProgressHUD.showAdded(to: StrongSelf.view, animated: true)
            PGVideoHelper.generousMixVideo(from: StrongSelf.asset, completionBlock: {[weak self] (mixVideoPath, url, success) in
                if self != nil {
                    MBProgressHUD.hide(for: self!.view, animated: true)
                }
                
                if success {
                    self?.asset.mixVideoPath = mixVideoPath
                    PGUserDefault.updateAsset(StrongSelf.asset)
                    self?.pushToVideoPreviewVC(mode: .editMode)
                } else {
                    showMessageNotifiaction("视频合成失败", on: self)
                    return
                }
            })
        }

        
//        if asset.videoPath == nil {
//            MBProgressHUD.showAdded(to: view, animated: true)
//            PGVideoHelper.generousOriginMovie(from: asset) {[weak self] (fileURL, duration) in
//                guard let StrongSelf = self else { return }
//                MBProgressHUD.hide(for: StrongSelf.view, animated: true)
//                
//                MBProgressHUD.showAdded(to: StrongSelf.view, animated: true)
//                PGVideoHelper.generousMixVideo(from: StrongSelf.asset, completionBlock: {[weak self] (mixVideoPath, url, success) in
//                    if self != nil {
//                        MBProgressHUD.hide(for: self!.view, animated: true)
//                    }
//                    
//                    if success {
//                        self?.asset.mixVideoPath = mixVideoPath
//                        self?.pushToVideoPreviewVC()
//                    } else {
//                        showMessageNotifiaction("视频合成失败", on: self)
//                        return
//                    }
//                })
//            }
//            
//            return
//        } else {
//            
//            MBProgressHUD.showAdded(to: view, animated: true)
//            PGVideoHelper.generousMixVideo(from: asset, completionBlock: {[weak self] (mixVideoPath, url, success) in
//                if self != nil {
//                    MBProgressHUD.hide(for: self!.view, animated: true)
//                }
//                
//                if success {
//                    self?.asset.mixVideoPath = mixVideoPath
//                    self?.pushToVideoPreviewVC()
//                } else {
//                    showMessageNotifiaction("视频合成失败", on: self)
//                    return
//                }
//            })
//        }
    }
    
    func pushToVideoPreviewVC(mode: VideoPreviewVC.PreviewVCMode = .editMode) {
        let vc = VideoPreviewVC()
        vc.asset = self.asset
        vc.vcMode = mode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension ImageAssetEditVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 防止横屏cell比例不对
        let height: CGFloat = collectionView.frame.height
        let screenHeight = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        let screenWidth = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        let width: CGFloat = (screenHeight / screenWidth) * height
//        print("\(width), \(height)")
        return CGSize(width: width, height: height)
    }
}

extension ImageAssetEditVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asset.imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard (0 ..< asset.imageList.count) ~= indexPath.row else {
            return UICollectionViewCell()
        }
        
        let pgImage = asset.imageList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageAssetPreviewCell", for: indexPath) as! imageAssetPreviewCell
        cell.configureCell(with: pgImage)
        cell.selectedCell(indexPath.row == selectedIndex)
        if indexPath.row == selectedIndex {
            previewImageView.image = pgImage.image
        }
        
        return cell
    }
}

extension ImageAssetEditVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (0 ..< asset.imageList.count) ~= indexPath.row else {
            return
        }
        
        let pgImage = asset.imageList[indexPath.row]
        previewImageView.image = pgImage.image
        
        self.selectedIndex = indexPath.row
        collectionView.reloadData()
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
}



