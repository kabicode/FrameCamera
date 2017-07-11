//
//  AudioRecordVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/11.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class AudioRecordVC: BaseViewController {

    @IBOutlet weak var playerContentView: UIView!
    @IBOutlet weak var playerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    var playerView: PGPlayerView!
    
    var recorderController: AudioRecorderController!
    var playerController: AudioPlayerController!
    
    var asset: PGAsset!
    
    var recordFilePath: String?
    
    deinit {
        print("")
    }
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "AudioRecordVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubView()
        
        defaultSetup()
    }
    
    func setupSubView() {
        playerView = PGPlayerView.loadFromNib()
        playerView.isUserInteractionEnabled = false
        playerView.delegate = self
        
        playerContentView.addSubview(playerView)
        playerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func defaultSetup() {
        playerViewHeightConstraint.constant = (UIScreen.main.bounds.width) / (UIScreen.main.bounds.height / UIScreen.main.bounds.width)
        playerView.layoutIfNeeded()
        
        if let url = asset.originVideoUrl {
            playerView.setVideo(with: url)
            playerView.playerView.player.isMuted = true
        }
        
        recorderController = AudioRecorderController()
        
        playerController = AudioPlayerController()
        playerController.delegate = self
    }

    
    // MARK: - Actions
    @IBAction func touchDownRecordBtn(_ sender: Any) {
        recordLabel.textColor = UIColor.yellowTheme
//        recordButton.isSelected = true
        
        startRecording()
    }

    @IBAction func touchUpRecordBtn(_ sender: Any) {
        recordLabel.textColor = UIColor.white
//        recordButton.isSelected = false
        // TODO
        pauseRecording()
    }
    
    @IBAction func tapPlayButton(_ sender: Any) {
        guard let filePath = recordFilePath else {
            let title = "暂无录音"
            let alert = UIAlertController.okAlert(title: title)
            present(alert, animated: true, completion: nil)
            return
        }
        
        if playerView.readyToPlay {
            playerView.play()
            playerController.playAudioFile(at: filePath)
        }
    }
    
    @IBAction func tapDeleteAudioButton(_ sender: Any) {
        
    }
    
    
    // MARK: - Private Method
    func startRecording() {
        guard canRecord() else { return }
        guard playerView.readyToPlay else { return }
        AudioSessionHelper.configureAudioSession(for: .record)
        
        guard recorderController.startRecord() else {
            let title = "录音失败"
            let alert = UIAlertController.okAlert(title: title)
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func pauseRecording() {
        let audioInfo = recorderController.pauseRecord()
        if audioInfo.filePath.characters.count > 0 {
            recordFilePath = audioInfo.filePath
            asset.audioPath = audioInfo.filePath
            PGUserDefault.updateAsset(asset)
        }
    }
    
    // MARK: - Helper
    private func canRecord() -> Bool {
        let session = AVAudioSession.sharedInstance()
        var recordGranted: Bool = true
        session.requestRecordPermission { granted in
            if granted {
                recordGranted = true
            } else {
                recordGranted = false
                
                let title = "未开启录音权限"
                let actionTitle = "去设置"
                let alert = UIAlertController.alert(
                    title: title,
                    actionTitle: actionTitle) { (action) in
                        guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
                        UIApplication.shared.openURL(url)
                }
                self.present(alert, animated: true, completion: nil)
            }
        }
        return recordGranted
    }

}

extension AudioRecordVC: AudioPlayerControllerDelegate {
    func audioPlayerDidFinishPlaying() {
        
    }
}

extension AudioRecordVC: PGPlayerViewProtocol {
    func playerViewReadyToPlay(_ playerView: PGPlayerView) {
        
    }
    
    func playerViewDidReachEnd(_ playerView: PGPlayerView) {
        playerController.stopAudioFile()
    }
}



