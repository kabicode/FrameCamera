//
//  AudioFileHelper.swift
//  Weike
//
//  Created by yake on 2016/10/9.
//  Copyright © 2016年 Kuaizai. All rights reserved.
//

import Foundation
import Alamofire

class PGAudioFileHelper {
    
    class func audioFileExists(_ filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    class func downloadAudio(_ fileURL: String, compelete: (()->())?) {
        Alamofire.download(fileURL) { _, _ in
            let filePath = PGAudioFileHelper.getFilePathFromURL(fileURL)
            return (URL(fileURLWithPath: filePath), .removePreviousFile)
        }.response { response in
            if let error = response.error {
                printLog("Failed with error: \(error)")
                // file exists
                if error._domain == NSCocoaErrorDomain && error._code == 516 {
                    compelete?()
                }
            } else {
                compelete?()
            }
        }
    }
    
    class func getFilePathFromURL(_ url: String) -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let fileString = url as NSString
        let components = fileString.components(separatedBy: "/")
        let fileName = components[components.count-1]
        return "\(documentDirectory)/audio/\(fileName)"
    }
    
    
    class func generateAudioFilePath() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let audioDirectory = "\(documentDirectory)/audio"
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName = "\(timestamp)_audio.aac"
        let audioFilePath = "\(audioDirectory)/\(fileName)"
        return audioFilePath
    }

    class func generateRecordAudioFilePath() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let audioDirectory = "\(documentDirectory)/recordAudio"
        if PGFileHelper.fileExists(audioDirectory) == false {
            do {
                try FileManager.default.createDirectory(atPath: audioDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(audioDirectory) --- 创建录音文件路径失败 ---")
            }
        }
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName = "\(timestamp)_录音.aac"
        let audioFilePath = "\(audioDirectory)/\(fileName)"
        return audioFilePath
    }

}
