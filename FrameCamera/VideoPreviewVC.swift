//
//  VideoPreviewVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/10.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit
import AssetsLibrary

class VideoPreviewVC: BaseViewController {

    enum PreviewVCMode {
        case editMode
        case saveMode
    }
    
    @IBOutlet weak var playContentView: UIView!
    @IBOutlet weak var playerContentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    
    var playerView: PGPlayerView!
    
    var asset: PGAsset!
    
    var vcMode: PreviewVCMode = .editMode
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "VideoPreviewVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if playerView.playerView.player.isPlaying {
            playerView.pause()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if playerView.readyToPlay && playerView.playedToEnd == false {
            playerView.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightItem = UIBarButtonItem.init(image: UIImage(named: "deleteVideo_btn")?.withRenderingMode(.alwaysOriginal),
                                             style: .plain,
                                             target: self,
                                             action: #selector(tapDeleteBarButton))
        navigationItem.rightBarButtonItem = rightItem
        
        playerContentViewHeightConstraint.constant = (UIScreen.main.bounds.width) / (UIScreen.main.bounds.height / UIScreen.main.bounds.width)
        playerView = PGPlayerView.loadFromNib()
        playContentView.addSubview(playerView)
        
        playerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        playerView.layoutIfNeeded()
        
        if let url = asset.videoUrl {
            let exit = FileManager.default.fileExists(atPath: PGFileHelper.getSandBoxPath(with: asset.videoPath!))
            let readable = FileManager.default.isReadableFile(atPath: PGFileHelper.getSandBoxPath(with: asset.videoPath!))
            print("\(exit), \(readable)")
            playerView.setVideo(with: url)
            playerView.delegate = self
        }
        
        setupButtons()
    }
    
    func setupButtons() {
        switch vcMode {
        case .editMode:
            firstBtn.setImage(UIImage(named:"editVideo_btn"), for: .normal)
            firstBtn.setTitle("编辑", for: .normal)
            firstBtn.addTarget(self, action: #selector(tapEditVideoButton), for: .touchUpInside)
            secondBtn.addTarget(self, action: #selector(tapShareVideoButton), for: .touchUpInside)
        case .saveMode:
            firstBtn.setImage(UIImage(named:"saveVideo_btn"), for: .normal)
            firstBtn.setTitle("保存", for: .normal)
            firstBtn.addTarget(self, action: #selector(tapSaveVideoButton), for: .touchUpInside)
            secondBtn.addTarget(self, action: #selector(tapShareVideoButton), for: .touchUpInside)
        }
    }
    
    // MARK: - Action
    func tapDeleteBarButton() {
        guard let _ = asset.videoUrl else {
            return;
        }
        
        let alert = UIAlertController.alert(title: "删除该视频?", message: nil, canCancel: true, cancelTitle: "否", actionTitle: "是") { [weak self] (action) in
            self?.deleteVideo()
        }
        present(alert, animated: true, completion: nil)
    }
    
    func tapSaveVideoButton() {
        guard let _ = asset.videoUrl else {
            showMessageNotifiaction("视频不存在", on: self)
            return
        }
        
        let library = ALAssetsLibrary()
        library.writeVideoAtPath(toSavedPhotosAlbum: asset.videoUrl!) { (url, error) in
            if error == nil {
                showMessageNotifiaction("保存视频成功", type: .success, on: self)
            } else {
                showMessageNotifiaction("保存视频失败", on: self)
            }
        }
    }
    
    func tapShareVideoButton() {
        let vc = PGShareViewController.loadFromStoryboard()
        vc.modalPresentationStyle = .overFullScreen
        vc.asset = asset
        present(vc, animated: true, completion: nil)
    }
    
    func tapEditVideoButton() {
        let vc = ImageAssetEditVC()
        vc.asset = asset
        navigationController?.pushViewController(vc, animated: true)
        
        delay(0.5) { [weak self] in
            if let navigationVC = self?.navigationController {
                if let index = navigationVC.viewControllers.index(of: self!) {
                    navigationVC.viewControllers.remove(at: index)
                }
            }
        }
    }
    
    // MARK: - Private Method
    func deleteVideo() {
        try? FileManager.default.removeItem(at: asset.videoUrl!)
        
        if asset.mixVideoPath != nil {
            asset.mixVideoPath = nil
        } else if asset.videoPath != nil {
            asset.videoPath = nil
        }
        
        PGUserDefault.updateAsset(asset)
        navigationController?.popViewController(animated: true)
    }
}

extension VideoPreviewVC: PGPlayerViewProtocol {
    func playerViewReadyToPlay(_ playerView: PGPlayerView) {
        playerView.play()
    }
    
    func playerViewDidReachEnd(_ playerView: PGPlayerView) {
        
    }
}

