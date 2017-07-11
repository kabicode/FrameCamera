//
//  AudioPlayerController.swift
//  Weike
//
//  Created by yake on 16/8/1.
//  Copyright © 2016年 Kuaizai. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire

protocol AudioPlayerControllerDelegate: class {
    func audioPlayerDidFinishPlaying()
}

class AudioPlayerController: NSObject {
    weak var delegate: AudioPlayerControllerDelegate?
    var audioPlayer: AVAudioPlayer?
    var avPlayer: AVPlayer?
    
    var isPlaying: Bool {
        if let player = audioPlayer, player.isPlaying {
            return true
        }
        if let player = avPlayer {
            // playing
            if player.rate != 0 && player.error != nil {
                return true
            }
        }
        return false
    }
    
    // AVAudioPlayer
    var duration: Int {
        if let player = audioPlayer {
            return Int(player.duration + 0.5)
        }
        return 0
    }
    
    var currentTime: Int {
        get {
            if let player = audioPlayer {
                return Int(player.currentTime + 0.5)
            }
            return 0
        }
        set {
            if let player = audioPlayer {
                player.currentTime = Double(newValue)
            }
        }
    }
    
    func playAudioFile(at filePath: String) {
//        guard let url = URL(string: filePath) else { return }
        let url = URL.init(fileURLWithPath: filePath)
        do {
            // don't new a player if play the same audio
            if audioPlayer?.url != url {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = self
            }
            audioPlayer?.play()
        } catch let error as NSError {
            printLog("Error to play: \(error.localizedDescription)")
        }
    }
    
    func pauseAudioFile() {
        audioPlayer?.pause()
    }
    
    func stopAudioFile() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    // AVPlayer
    func playAudioStream(with url: URL) {
        let playerItem = AVPlayerItem(url: url)
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer?.play()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidFinish),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: playerItem)
    }
    
    func stopAudioStream() {
        avPlayer?.pause()
        
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil)
    }
    
    func playerItemDidFinish() {
        delegate?.audioPlayerDidFinishPlaying()
    }
}

extension AudioPlayerController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            delegate?.audioPlayerDidFinishPlaying()
        }
    }
}
