//
//  PGPlayerView.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/10.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class PGPlayerView: UIView {
    enum PGPlayerViewScreenState {
        case normal
        case animating
        case fullScreen
    }

    @IBOutlet weak var controlBoardView: UIView!
    @IBOutlet weak var playBgBlurView: UIVisualEffectView!
    @IBOutlet weak var bottomBgBlurView: UIVisualEffectView!
    @IBOutlet weak var videoProgress: UISlider!
    @IBOutlet weak var videoDurationLabel: UILabel!
    @IBOutlet weak var bottomPauseBtn: UIButton!
    
    @IBOutlet var playerView: VIMVideoPlayerView!
    
    var viewScreenState: PGPlayerViewScreenState = .normal
    var originSuperView: UIView?
    var originFrame: CGRect?
    
    var readyToPlay: Bool = false
    var currentSecond: Int = 0
    var videoDuration: Int = 0
    
    
    static func loadFromNib() -> PGPlayerView {
        return Bundle.main.loadNibNamed("PGPlayerView", owner: nil, options: nil)![0] as! PGPlayerView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playBgBlurView.layer.cornerRadius = playBgBlurView.frame.height / 2.0
        playBgBlurView.layer.masksToBounds = true
        
        playerView.backgroundColor = UIColor.black
        playerView.player.disableAirplay()
        playerView.setVideoFillMode(AVLayerVideoGravityResizeAspectFill)
        playerView.delegate = self
        
        playerView.layer.masksToBounds = true
        playerView.addSubview(controlBoardView)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapFullScreenButton))
        playerView.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if playerView.superview == self {
            playerView.frame = bounds
            controlBoardView.frame = bounds
        }
    }
    
    // MARK: - Public Method
    func playVideo(with url: URL) {
        readyToPlay = false
        playerView.player.setURL(url)
    }

    func play() {
        if readyToPlay && playerView.player.isPlaying == false {
            playBgBlurView.isHidden = true
            playerView.player.play()
        }
    }
    
    func pause() {
        playBgBlurView.isHidden = false
        playerView.player.pause()
    }
    
    // MARK: - Actions
    @IBAction func tapFullScreenButton(_ sender: Any) {
        if viewScreenState == .normal {
            enterFullScreen()
        } else if viewScreenState == .fullScreen {
            exitFullScreen()
        }
    }
    
    @IBAction func tapPlayButton(_ sender: Any) {
        play()
    }
    
    @IBAction func tapPauseButton(_ sender: Any) {
        pause()
    }
    
    @IBAction func slideProgressValueDidChange(_ sender: Any) {
        currentSecond = Int((videoProgress.value) * Float(videoDuration))
        updateVideoDurationLabel()
    }
    
    @IBAction func dragVideoProgress(_ sender: Any) {
        let time = (videoProgress.value) * Float(videoDuration)
//        playerView.player.seek(toTime: time)
        playerView.player.seek(toTime: time) {
            
        }
        updateVideoDurationLabel()
    }
    

    // MARK: - Private Method
    func enterFullScreen() {
        guard let superView = playerView.superview,
            let window = UIApplication.shared.keyWindow,
            viewScreenState == .normal else {
            return
        }
        
        viewScreenState = .animating
        originSuperView = superView
        originFrame = playerView.frame
        
        
        let rectInWindow = playerView.convert(playerView.bounds, to: window)
        
        playerView.removeFromSuperview()
        playerView.frame = rectInWindow
        window.addSubview(playerView)
        
        UIView.animate(withDuration: 0.5, animations: { 
            self.playerView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            self.playerView.bounds = CGRect.init(x: 0, y: 0, width: window.bounds.height, height: window.bounds.width)
            self.playerView.center = CGPoint.init(x: window.bounds.midX, y: window.bounds.midY)
            self.controlBoardView.frame = self.playerView.bounds
            self.controlBoardView.layoutIfNeeded()
        }, completion: { finished in
            self.viewScreenState = .fullScreen
        })
        
        refreshStatusBar(orientation: .landscapeRight)
    }
    
    func exitFullScreen() {
        guard viewScreenState == .fullScreen,
            let window = UIApplication.shared.keyWindow,
            let superView = originSuperView,
            let rect = originFrame
            else {
                return
        }
        
        viewScreenState = .animating
        
        let frame = superView.convert(rect, to: window)
        UIView.animate(withDuration: 0.5, animations: {
            self.playerView.transform = CGAffineTransform.identity
            self.playerView.frame = frame
            self.controlBoardView.frame = self.playerView.bounds
            self.controlBoardView.layoutIfNeeded()
            
        }, completion: { finished in
            
            self.playerView.removeFromSuperview()
            self.playerView.frame = rect
            self.originSuperView?.addSubview(self.playerView)
            self.viewScreenState = .normal
        })
        
        refreshStatusBar(orientation: .portrait)
    }
    
    func refreshStatusBar(orientation: UIInterfaceOrientation) {
        UIApplication.shared.setStatusBarOrientation(orientation, animated: true)
    }
    
    func updateVideoDurationLabel() {
        videoDurationLabel.text = String.init(format: "%.2d:%.2d/%.2d:%.2d", currentSecond/60, currentSecond%60, videoDuration/60, videoDuration%60)
    }
}

extension PGPlayerView: VIMVideoPlayerViewDelegate {
//    - (void)videoPlayerViewIsReadyToPlayVideo:(VIMVideoPlayerView *)videoPlayerView;
//    - (void)videoPlayerViewDidReachEnd:(VIMVideoPlayerView *)videoPlayerView;
//    - (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView timeDidChange:(CMTime)cmTime;
//    - (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView loadedTimeRangeDidChange:(float)duration;
//    - (void)videoPlayerViewPlaybackBufferEmpty:(VIMVideoPlayerView *)videoPlayerView;
//    - (void)videoPlayerViewPlaybackLikelyToKeepUp:(VIMVideoPlayerView *)videoPlayerView;
//    - (void)videoPlayerView:(VIMVideoPlayerView *)videoPlayerView didFailWithError:(NSError *)error;
    func videoPlayerViewIsReady(toPlayVideo videoPlayerView: VIMVideoPlayerView!) {
        readyToPlay = true
    
        videoDuration = Int((playerView.player.player.currentItem?.duration.seconds)!)
        updateVideoDurationLabel()
    }
    
    func videoPlayerView(_ videoPlayerView: VIMVideoPlayerView!, timeDidChange cmTime: CMTime) {
        currentSecond = Int(Float(cmTime.value) / Float(cmTime.timescale))
        videoProgress.setValue((Float(cmTime.value) / Float(cmTime.timescale) / Float(videoDuration)), animated: true)
        updateVideoDurationLabel()
    }
    
    func videoPlayerViewDidReachEnd(_ videoPlayerView: VIMVideoPlayerView!) {
//        readyToPlay = false
        
        pause()
    }
    
    func videoPlayerView(_ videoPlayerView: VIMVideoPlayerView!, didFailWithError error: Error!) {
        print("\(error)")
        showToast("视频播放失败")
    }
}

