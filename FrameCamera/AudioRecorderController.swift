//
//  AudioRecorderController.swift
//  Weike
//
//  Created by yake on 16/8/1.
//  Copyright © 2016年 Kuaizai. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftyJSON

class AudioRecorderController {
    static let audioSampleRateDefault = 44100
    static let audioNumberOfChannelDefault = 1
    static let audioBitRateDefault = 64000
    
    var audioRecorder: AVAudioRecorder?
    var recorderSettings: [String: Any]
    var audioFilePath: String!
    
    var isRecording: Bool {
        if let recorder = audioRecorder {
            return recorder.isRecording
        }
        return false
    }
    
    var audioCurrentTime: Int {
        if let recorder = audioRecorder {
            return Int(recorder.currentTime + 0.5)
        }
        return 0
    }
    
    var audioPower: Double {
        guard let recorder = audioRecorder else { return 0.0 }
        
        recorder.updateMeters()
        return Double(recorder.peakPower(forChannel: 0))
    }
    
    init() {
        recorderSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: AudioRecorderController.audioSampleRateDefault,
            AVNumberOfChannelsKey: AudioRecorderController.audioNumberOfChannelDefault,
            AVLinearPCMBitDepthKey: 8,
            AVEncoderBitRateKey: AudioRecorderController.audioBitRateDefault,
        ]
    }
    
    func startRecord() -> Bool {
        do {
            if audioRecorder == nil {
                audioFilePath =  PGAudioFileHelper.generateRecordAudioFilePath()
                printLog("Record audio to: \(audioFilePath)")
                let audioFileURL = URL(fileURLWithPath: audioFilePath)
                audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: recorderSettings)
                audioRecorder?.isMeteringEnabled = true
                audioRecorder?.prepareToRecord()
            }
            if let recorder = audioRecorder {
                return recorder.record()
            } else {
                return false
            }
        } catch let error as NSError {
            printLog("Error to record: \(error.localizedDescription)")
            return false
        }
    }
    
    func pauseRecord() -> (filePath: String, duration: Int) {
        guard let recorder = audioRecorder else { return ("", 0) }
        recorder.pause()
        let duration = Int(recorder.currentTime + 0.5)
        return (audioFilePath, duration)
    }
    
    func stopRecord() -> (filePath: String, duration: Int) {
        if let audioRecorder = audioRecorder {
            let duration = Int(audioRecorder.currentTime + 0.5)
            audioRecorder.stop()
            self.audioRecorder = nil
            return (audioFilePath, duration)
        }
        return ("", 0)
    }

}
