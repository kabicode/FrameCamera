//
//  UsingTutorialVC.swift
//  PingGuo
//
//  Created by ShenMu on 2018/9/26.
//  Copyright © 2018年 ShenMu. All rights reserved.
//

import UIKit
import Alamofire

class UsingTutorialVC: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var downloadTask: DownloadRequest?
    
    var assetsArray: [GuideAssetModel] = []
    
    static func loadFromStoryboard() -> UsingTutorialVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "UsingTutorialVC") as! UsingTutorialVC
        return viewController
    }
    
    deinit {
        self.downloadTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        
        loadAssetList()
    }
    
    func setupSubviews() {
        self.title = "教学视频"
        self.collectionView.contentInset = UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    // MARK: - Actions
    //    @IBAction func tapCreateButton(_ sender: Any) {
    //        let asset = PGAsset(filePath: PGFileHelper.generateImageAssetFilePath())
    //        PGUserDefault.addAsset(asset)
    //
    //        let _ = CreateSnapShotViewController.presentFrom(self, with: asset)
    //    }
    
    func tapSettingButton() {
        let vc = ProfileViewController.loadFromStoryboard()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Private Method
    func loadAssetList() {
        let request = Router.GuideAsset.guideAssetList
        NetworkHelper.sendNetworkRequest(request: request, showHUD: true, successHandler: { (json) in
            self.assetsArray.removeAll()
            let assets = json["Data"].arrayValue
            assets.forEach({[weak self] (json) in
                let asset: GuideAssetModel = GuideAssetModel.init(from: json)
                self?.assetsArray.append(asset)
                self?.collectionView.reloadData()
                self?.loadAssetDownloadLink(with: asset, completeHandle: nil)
            })
            
        }, failureHandler: { _ in
            showToast("获取教程失败")
        })
    }
    
    func loadAssetDownloadLink(with asset:GuideAssetModel, completeHandle:((_ zipUrl: String) -> Void)?) {
        guard asset.id != 0 else {
            return
        }
        
        let request = Router.GuideAsset.guideAssetDetail("\(asset.id)")
        NetworkHelper.sendNetworkRequest(request: request, showHUD: false, successHandler: { (json) in
            let zipPath: String = json.stringValue
            if zipPath.count > 0 {
                asset.zipPath = zipPath
                let filePath = PGFileHelper.getGuideAssetZipFilePathFrom(url: zipPath)
                if PGFileHelper.fileExists(filePath) {
                    asset.isDownloaded = true
                    self.collectionView.reloadData()
                }
            }
            completeHandle?(zipPath)
            
        }, failureHandler: { _ in
            completeHandle?("")
        })
    }
    
}

extension UsingTutorialVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard (0 ..< assetsArray.count) ~= indexPath.row else {
            return UICollectionViewCell()
        }
        
        let asset = assetsArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuideAssetCell", for: indexPath) as! GuideAssetCell
        cell.configureCell(with: asset)
        cell.layer.borderColor = UIColor(hex: 0x8B8B8B).cgColor
        cell.layer.borderWidth = 1
        return cell
    }
}

extension UsingTutorialVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 2 - 3
        let height = width * (UIScreen.main.bounds.width/UIScreen.main.bounds.height)
        return CGSize(width: width, height: height)
    }
}

extension UsingTutorialVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (0 ..< assetsArray.count) ~= indexPath.row else {
            return
        }
        
        let asset: GuideAssetModel = self.assetsArray[indexPath.row]
        if asset.zipPath.count > 0 {
            self.downloadAndUnzipAsset(asset)
        } else {
            self.loadAssetDownloadLink(with: asset) {[weak self] (zipUrl) in
                self?.downloadAndUnzipAsset(asset)
            }
        }
    }
    
    func downloadAndUnzipAsset(_ asset: GuideAssetModel) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.downloadTask = PGFileHelper.downloadGuideAssetZip(asset.zipPath) { [weak self] (zipPath, success) in
            if let zip = zipPath {
                PGFileHelper.unzipGuideAsset(zip, compelete: { [weak self] (unzipPath, success, imageFiles) in
                    guard let strongSelf = self else { return }
                    MBProgressHUD.hide(for: strongSelf.view, animated: true)
                    asset.isDownloaded = success
                    asset.imageFiles = imageFiles
                    strongSelf.collectionView.reloadData()
                    
                    if imageFiles.count > 0 {
                        let pgAsset = PGAsset(filePath: PGFileHelper.generateImageAssetFilePath())
                        PGUserDefault.addAsset(pgAsset)
                        
                        let vc = CreateSnapShotViewController.presentFrom(strongSelf, with: pgAsset)
                        vc.snapshotMode = .guideMode
                        vc.guideAsset = asset
                        vc.dismissBlock = { [weak self] in
                            let editVC = ImageAssetEditVC()
                            editVC.asset = pgAsset
                            self?.navigationController?.pushViewController(editVC, animated: true)
                        }
                    }
                })
            }
        }
    }

}
