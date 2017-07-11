//
//  AudioEffectEditVC.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/6.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class AudioEffectEditVC: BaseViewController {

    enum TabBarSelectedType {
        case audioLibraryVC
        case recordAudioVC
    }
    
    @IBOutlet weak var tabBar: UITabBar!
    
    var audioRecordVC: AudioRecordVC!
    
    var asset: PGAsset!
    
    var tabBarSelectedType: TabBarSelectedType = .audioLibraryVC
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "AudioEffectEditVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubView()
        
        tabBar.selectedItem = tabBar.items?.first
    }
    
    func setupSubView() {
        tabBar.delegate = self
        tabBar.tintColor = UIColor.yellowTheme
        tabBar.barTintColor = UIColor(hex: 0x1A212B)
        tabBar.isTranslucent = false
        
        audioRecordVC = AudioRecordVC()
        audioRecordVC.asset = asset
        addChildViewController(audioRecordVC)
        
        // TODO
        
        
        let rightItem = UIBarButtonItem.init(image: UIImage(named: "done_black_barbutton")?.withRenderingMode(.alwaysOriginal),
                                             style: .plain,
                                             target: self,
                                             action: #selector(tapDoneBarButton))
        navigationItem.rightBarButtonItem = rightItem
    }

    // Actions
    func tapDoneBarButton() {
        // TODO 合成视频
        if tabBarSelectedType == .recordAudioVC {
            audioRecordVC.stopRecording()
        } else if tabBarSelectedType == .audioLibraryVC {
            
        }
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
            tabBarSelectedType = .audioLibraryVC
            addMusicLibraryView()
        } else if item.title == "录音" {
            tabBarSelectedType = .recordAudioVC
            addAudioRecordView()
        }
    }
}
