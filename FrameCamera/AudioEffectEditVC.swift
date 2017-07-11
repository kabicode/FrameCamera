//
//  AudioEffectEditVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/6.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class AudioEffectEditVC: BaseViewController {

    @IBOutlet weak var tabBar: UITabBar!
    
    var audioRecordVC: AudioRecordVC!
    
    var asset: PGAsset!
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "AudioEffectEditVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioRecordVC = AudioRecordVC()
        audioRecordVC.asset = asset
        addChildViewController(audioRecordVC)
        
        tabBar.delegate = self
    }

    
    // Private Method
    func addMusicLibraryView() {
        
    }
    
    func addAudioRecordView() {
        if audioRecordVC.view.superview == nil {
            view.addSubview(audioRecordVC.view)
            audioRecordVC.view.snp.makeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(tabBar.snp.top)
            })
        } else {
            view.bringSubview(toFront: audioRecordVC.view)
        }
    }

}

extension AudioEffectEditVC: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "音乐库" {
            addMusicLibraryView()
        } else if item.title == "录音" {
            addAudioRecordView()
        }
    }
}
