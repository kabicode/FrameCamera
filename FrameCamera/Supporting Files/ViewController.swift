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
        
        collectionView.contentInset = UIEdgeInsets.init(top: 16, left: 8, bottom: 16, right: 8)
        loadData()
    }
    
    
    // MARK: - Actions
    @IBAction func tapCreateButton(_ sender: Any) {
        let asset = PGAsset(filePath: PGFileHelper.generateImageAssetFilePath())
        PGUserDefault.addAsset(asset)
        
        let _ = CreateSnapShotViewController.presentFrom(self, with: asset)
    }
    
    
    // MARK: - Private Method
    func loadData() {
        assetsArray = PGUserDefault.assetsArray
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
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 16.0 - 16.0
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
