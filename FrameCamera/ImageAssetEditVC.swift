//
//  ImageAssetEditVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/1.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

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
    }

    // MARK: - Actions
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
        vc.isSingleShotMode = true
        let index = (self.selectedIndex != nil) ? self.selectedIndex! + 1: 0
        
        vc.singleShotBlock = {[weak self] image in
            let _ = self?.asset.add(image, at: index)
            self?.selectedIndex = index
            self?.selectedImageItem(at: index)
        }
    }
    
    
    @IBAction func tapPreviewButton(_ sender: Any) {
    }

    @IBAction func tapSpecialEffecButton(_ sender: Any) {
    }
    
    @IBAction func tapAudioButton(_ sender: Any) {
    }
    
    // Private Method
    func selectedImageItem(at index: Int?) {
        if let selectedIndex = index {
            collectionView(collectionView, didSelectItemAt: IndexPath.init(row: selectedIndex, section: 0))
        } else {
            collectionView.reloadData()
        }
    }
}


extension ImageAssetEditVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = collectionView.frame.height
        let width: CGFloat = (UIScreen.main.bounds.height / UIScreen.main.bounds.width) * height
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
        cell.backgroundColor = UIColor.red
        cell.selectedCell(indexPath.row == selectedIndex)
        return cell
    }
}

extension ImageAssetEditVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (0 ..< asset.imageList.count) ~= indexPath.row else {
            return
        }
        
        let pgImage = asset.imageList[indexPath.row]
        previewImageView.image = PGFileHelper.restoreImage(at: pgImage.imagePath)
        
        self.selectedIndex = indexPath.row
        collectionView.reloadData()
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
}



