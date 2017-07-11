//
//  ViewController.swift
//  FrameCamera
//
//  Created by ShenMu on 2017/5/16.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var assetsArray: [PGAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        setupSubviews()
        
        loadData()
    }
    
    func setupSubviews() {
        title = "视频相册"
        
        let rightItem = UIBarButtonItem.init(image: UIImage(named: "setting_white_btn")?.withRenderingMode(.alwaysOriginal),
                                             style: .plain,
                                             target: self,
                                             action: #selector(tapSettingButton))
        navigationItem.rightBarButtonItem = rightItem
        
        
        collectionView.contentInset = UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    // MARK: - Actions
    @IBAction func tapCreateButton(_ sender: Any) {
        let asset = PGAsset(filePath: PGFileHelper.generateImageAssetFilePath())
        PGUserDefault.addAsset(asset)
        
        let _ = CreateSnapShotViewController.presentFrom(self, with: asset)
    }
    
    func tapSettingButton() {
        // TODO
    }
    
    
    // MARK: - Private Method
    func loadData() {
        
        var shouleSave: Bool = false
        
        assetsArray = PGUserDefault.assetsArray
        for asset in assetsArray {
            if asset.imageList.count == 0 {
                if let index = assetsArray.index(of: asset) {
                    shouleSave = true
                    assetsArray.remove(at: index)
                    PGFileHelper.removeFolder(PGFileHelper.getSandBoxPath(with: asset.filePath))
                }
            }
        }
        
        if shouleSave {
            PGUserDefault.assetsArray = assetsArray
        }
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard (0 ..< assetsArray.count) ~= indexPath.row else {
            return UICollectionViewCell()
        }
        
        let asset = assetsArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoLibraryCell", for: indexPath) as! VideoLibraryCell
        cell.configureCell(with: asset)
        cell.layer.borderColor = UIColor(hex: 0x8B8B8B).cgColor
        cell.layer.borderWidth = 1
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 6
        let height = width * (UIScreen.main.bounds.width/UIScreen.main.bounds.height)
        return CGSize(width: width, height: height)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (0 ..< assetsArray.count) ~= indexPath.row else {
            return
        }
        
        let asset = assetsArray[indexPath.row]
        let vc = ImageAssetEditVC()
        vc.asset = asset
        navigationController?.pushViewController(vc, animated: true)
    }
}
