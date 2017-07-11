//
//  AudioSessionHelper.swift
//  Weike
//
//  Created by yake on 2016/10/21.
//  Copyright © 2016年 Kuaizai. All rights reserved.
//

import Foundation
import AVFoundation

class AudioSessionHelper {
    enum AudioSessionScene {
        case play
        case record
        case other
    }
    
    static var currentScene: AudioSessionScene = .other
    
    static func configureAudioSession(for scene: AudioSessionScene) {
        // don't configure audio session if it don't change
//        guard self.currentScene != scene else { return }
        
        let session = AVAudioSession.sharedInstance()
        do {
            var options: AVAudioSessionCategoryOptions = [.allowBluetooth, .defaultToSpeaker]
            switch scene {
            case .record:
                options.insert(.mixWithOthers)
            case .play, .other:
                // don't set mixWithOthers when play for RemoteControlCenter
                break
            }
            try session.setCategory(
                AVAudioSessionCategoryPlayAndRecord,
                with: options)
            try session.setActive(true)
            self.currentScene = scene
        } catch let error as NSError {
            let format = "配置audioSession错误，%@"
            let message = String(format: format, error.localizedDescription)
            showMessageNotifiaction(message)
        }
    }

}
