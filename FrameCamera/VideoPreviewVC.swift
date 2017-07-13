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
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "VideoPreviewVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerView = PGPlayerView.loadFromNib()
        view.addSubview(playerView)
        
        playerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(view).offset(20)
            make.height.equalTo(300)
        }
        playerView.layoutIfNeeded()
        
        if let url = asset.videoUrl {
            playerView.setVideo(with: url)
        }
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
