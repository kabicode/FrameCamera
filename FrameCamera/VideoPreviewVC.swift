//
//  VideoPreviewVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/10.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class VideoPreviewVC: BaseViewController {

    var playerView: PGPlayerView!
    
    var asset: PGAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerView = PGPlayerView.loadFromNib()
        playerView.frame = CGRect.init(x: 0, y: 0, width: 300, height: 300)
//        playerView.center = view.center
        view.addSubview(playerView)
        
//        playerView.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//            make.left.equalTo(view).offset(20)
//            make.height.equalTo(300)
//        }
        playerView.layoutIfNeeded()
        
        if (asset.videoPath != nil) {
            let videoPath = PGFileHelper.getSandBoxPath(with: asset.videoPath!)
            let url = URL.init(fileURLWithPath: videoPath)
            playerView.playVideo(with: url)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapFullScreenButton))
        playerView.addGestureRecognizer(tap)
    }
    
    func tapFullScreenButton() {
        guard let superView = playerView.superview,
            let window = UIApplication.shared.keyWindow,
            playerView.viewScreenState == .normal else {
                return
        }
        playerView.snp.removeConstraints()
        playerView.viewScreenState = .animating
        playerView.originSuperView = superView
        playerView.originFrame = playerView.frame
        
        
        let rectInWindow = playerView.convert(playerView.bounds, to: window)
        
        playerView.removeFromSuperview()
        playerView.frame = rectInWindow
        window.addSubview(playerView)
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.playerView.bounds = CGRect.init(x: 0, y: 0, width: window.bounds.height, height: window.bounds.width)
            self.playerView.center = CGPoint.init(x: window.bounds.midX, y: window.bounds.midY)
            self.playerView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
//            self.playerView.frame.origin.x = 0
//            self.playerView.frame.origin.y = 0
            self.playerView.playerView.frame = self.playerView.bounds
        }, completion: { finished in
            self.playerView.viewScreenState = .fullScreen
        })
        
        playerView.refreshStatusBar(orientation: .landscapeRight)
    }

}
