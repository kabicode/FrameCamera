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

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var controlBoardView: UIView!
    @IBOutlet var playerView: VIMVideoPlayerView!
    
    var viewScreenState: PGPlayerViewScreenState = .normal
    var originSuperView: UIView?
    var originFrame: CGRect?
    
    static func loadFromNib() -> PGPlayerView {
        return Bundle.main.loadNibNamed("PGPlayerView", owner: nil, options: nil)![0] as! PGPlayerView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playerView.backgroundColor = UIColor.black
        playerView.player.disableAirplay()
        playerView.setVideoFillMode(AVLayerVideoGravityResizeAspectFill)
        playerView.delegate = self
        
        addSubview(controlBoardView)
//        playerView.frame = CGRect.init(x: 0, y: 0, width: 500, height: 300)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerView.frame = bounds
        controlBoardView.frame = bounds
    }
    
    // MARK: - Public Method
    func playVideo(with url: URL) {
        playerView.player.setURL(url)
    }

    // MARK: - Actions
    @IBAction func tapFullScreenButton(_ sender: Any) {
        if viewScreenState == .normal {
            enterFullScreen()
        } else if viewScreenState == .fullScreen {
            exitFullScreen()
        }
    }

    // MARK: - Private Method
    func enterFullScreen() {
        guard let superView = contentView.superview,
            let window = UIApplication.shared.keyWindow,
            viewScreenState == .normal else {
            return
        }
        
        viewScreenState = .animating
        originSuperView = superView
        originFrame = contentView.frame
        
        
        let rectInWindow = contentView.convert(contentView.bounds, to: window)
        
        contentView.removeFromSuperview()
        contentView.frame = rectInWindow
        window.addSubview(contentView)
        
        UIView.animate(withDuration: 0.5, animations: { 
//            self.playerView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            self.contentView.bounds = CGRect.init(x: 0, y: 0, width: window.bounds.height, height: window.bounds.width)
            self.contentView.center = CGPoint.init(x: window.bounds.midX, y: window.bounds.midY)
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
}

extension PGPlayerView: VIMVideoPlayerViewDelegate {
    func videoPlayerViewIsReady(toPlayVideo videoPlayerView: VIMVideoPlayerView!) {
        playerView.player.play()
    }
}

