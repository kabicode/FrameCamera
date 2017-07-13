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
    
    var audioLibraryVC: AudioLibraryVC!
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
        configureSubViews()
    }
    
    func setupSubView() {
        tabBar.delegate = self
        tabBar.tintColor = UIColor.yellowTheme
        tabBar.barTintColor = UIColor(hex: 0x1A212B)
        tabBar.isTranslucent = false
        
        audioLibraryVC = AudioLibraryVC()
        audioLibraryVC.asset = asset
        addChildViewController(audioLibraryVC)
        
        audioRecordVC = AudioRecordVC()
        audioRecordVC.asset = asset
        addChildViewController(audioRecordVC)
        
        let rightItem = UIBarButtonItem.init(image: UIImage(named: "done_black_barbutton")?.withRenderingMode(.alwaysOriginal),
                                             style: .plain,
                                             target: self,
                                             action: #selector(tapDoneBarButton))
        navigationItem.rightBarButtonItem = rightItem
    }

    // Actions
    func tapDoneBarButton() {
        if tabBarSelectedType == .recordAudioVC {
            audioRecordVC.stopRecording()
            asset.audioPath = audioRecordVC.recordFilePath == nil ? nil: PGAudioFileHelper.getAuidoFilePathFromSandBoxPath(audioRecordVC.recordFilePath!)
        } else if tabBarSelectedType == .audioLibraryVC {
            asset.audioPath = audioLibraryVC.selectedAudioPath == nil ? nil : PGAudioFileHelper.getAuidoFilePathFromSandBoxPath(audioLibraryVC.selectedAudioPath!)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // Private Method
    func configureSubViews() {
        if tabBarSelectedType == .audioLibraryVC {
            addMusicLibraryView()
        } else if tabBarSelectedType == .recordAudioVC {
            addAudioRecordView()
        }
    }
    
    func addMusicLibraryView() {
        if audioLibraryVC.view.superview == nil {
            view.addSubview(audioLibraryVC.view)
            audioLibraryVC.view.snp.makeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                make.bottom.equalTo(tabBar.snp.top)
            })
        } else {
            view.bringSubview(toFront: audioLibraryVC.view)
        }
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
        } else if item.title == "录音" {
            tabBarSelectedType = .recordAudioVC
        }
        configureSubViews()
    }
}
