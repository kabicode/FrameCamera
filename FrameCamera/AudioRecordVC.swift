//
//  AudioRecordVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/11.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class AudioRecordVC: BaseViewController {
    enum RecordState {
        case perparToRecord
        case recording
        case pauseRecord
        case endRecord
    }

    @IBOutlet weak var playerContentView: UIView!
    @IBOutlet weak var playerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    var playerView: PGPlayerView!
    
    var recorderController: AudioRecorderController!
    var playerController: AudioPlayerController!
    
    var asset: PGAsset!
    
    var recordFilePath: String?
    
    var recordState: RecordState = .perparToRecord
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
        recorderController.stopRecord()
        playerController.stopAudioFile()
        playerView.pause()
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
        showPlayAndDeleteButton(false)
    }

    @IBAction func touchUpRecordBtn(_ sender: Any) {
        recordLabel.textColor = UIColor.white
        
        if recordState == .recording {
            pauseRecording()
        }
        showPlayAndDeleteButton(true)
    }
    
    @IBAction func tapPlayButton(_ sender: Any) {
        guard let filePath = recordFilePath else {
            let title = "暂无录音"
            let alert = UIAlertController.okAlert(title: title)
            present(alert, animated: true, completion: nil)
            return
        }
        
        if (recordState == .recording) || (recordState == .pauseRecord) {
            let alert = UIAlertController.alert(title: "是否完成录音？",
                                                message: nil,
                                                actionTitle: "确定",
                                                actionHandler:
                { [weak self] (action) in
                    self?.stopRecording()
                    AudioSessionHelper.configureAudioSession(for: .play)
                    self?.playerView.reset()
                    self?.playerView.play()
                    self?.playerController.playAudioFile(at: filePath)
            })
            present(alert, animated: true, completion: nil)
            return
        }
        
        AudioSessionHelper.configureAudioSession(for: .play)
        if playerView.readyToPlay {
            playerView.reset()
            playerView.play()
            playerController.playAudioFile(at: filePath)
        }
    }
    
    @IBAction func tapDeleteAudioButton(_ sender: Any) {
        guard let _ = recordFilePath else {
            return
        }
        
        let alert = UIAlertController.alert(title: "确定删除录音？",
                                            message: nil,
                                            actionTitle: "确定",
                                            actionHandler:
            { [weak self] (action) in
                self?.stopRecording()
                self?.playerView.reset()
                self?.deleteRecordIfNeed()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Private Method
    func startRecording() {
        guard canRecord() else { return }
        guard playerView.readyToPlay else { return }
        
        print("\(recorderController.recordedTime), \(asset.duration)")
        if recordState == .endRecord && recordFilePath != nil {
            let alert = UIAlertController.alert(title: "是否重新录音？",
                                                message: "录音已存在，是否删除重新录制？",
                                                actionTitle: "确定",
                                                actionHandler:
                {[weak self] (action) in
                    self?.stopRecording()
                    self?.playerView.reset()
                    self?.recordState = .perparToRecord
            })
            present(alert, animated: true, completion: nil)
            return
        }
        
        if recordState == .perparToRecord {
            playerController.stopAudioFile()
            playerView.reset()
        }
        
        recordState = .recording
        AudioSessionHelper.configureAudioSession(for: .record)
        guard recorderController.startRecord(at: recordFilePath) else {
            let title = "录音失败"
            let alert = UIAlertController.okAlert(title: title)
            present(alert, animated: true, completion: nil)
            return
        }
        
        playerView.play()
    }
    
    func pauseRecording() {
        recordState = .pauseRecord
        
        var audioInfo: (filePath: String, duration: Int)
        audioInfo = recorderController.pauseRecord()
        
        playerView.pause()
        if audioInfo.filePath.characters.count > 0 {
            recordFilePath = audioInfo.filePath
        }
    }
    
    func stopRecording() {
        recordState = .endRecord
        var audioInfo = recorderController.stopRecord()
        
        playerView.pause()
        if audioInfo.filePath.characters.count > 0 {
            recordFilePath = audioInfo.filePath
            NotificationCenter.default.post(name: NSNotification.Name("ShouldRefreshLocalMusicList"), object: nil)
        }
    }
    
    func deleteRecordIfNeed() {
        if let filePath = recordFilePath {
            PGAudioFileHelper.deleteAudioFile(at: filePath)
            recordFilePath = nil
            asset.audioPath = nil
            NotificationCenter.default.post(name: NSNotification.Name("ShouldRefreshLocalMusicList"), object: nil)
        }
    }
    
    func showPlayAndDeleteButton(_ show: Bool) {
        let alpha: CGFloat = show ? 1.0: 0.0
        UIView.animate(withDuration: 0.25) { 
            self.playButton.alpha = alpha
            self.deleteButton.alpha = alpha
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
        if recordState == .recording {
            stopRecording()
        }
        
        if playerController.isPlaying {
            playerController.stopAudioFile()
        }
    }
}



