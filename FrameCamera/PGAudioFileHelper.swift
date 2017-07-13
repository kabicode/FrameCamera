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
    
    static func audioFileExists(_ filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    static func getFileNameFromURL(_ url: String) -> String {
        let fileString = url as NSString
        let components = fileString.components(separatedBy: "/")
        let fileName = components.last ?? "Empty"
        return fileName
    }
    
    private static func getFilePathFromURL(_ url: String) -> String {
        let audioDirectory = getLocalAudiosFolderPath()
        
        let fileString = url as NSString
        let components = fileString.components(separatedBy: "/")
        let fileName = components.last ?? "Empty"
        return audioDirectory + "/" + fileName
    }

    static func getAuidoFilePathFromSandBoxPath(_ sandboxPath: String) -> String {
        let documentDirectory = PGFileHelper.getPingGuoFilePath()
        let filePath = sandboxPath.replacingOccurrences(of: documentDirectory, with: "")
        return filePath
    }
    
    // 获取真实沙盒路径
    static func downloadAudio(_ fileURL: String, compelete: ((_ audioPath: String?, _ success: Bool)->())?) {
        let filePath = PGAudioFileHelper.getFilePathFromURL(fileURL)
        Alamofire.download(fileURL) { _, _ in
            return (URL(fileURLWithPath: filePath), .removePreviousFile)
            }.response { response in
                if let error = response.error {
                    printLog("Failed with error: \(error)")
                    // file exists
                    if error._domain == NSCocoaErrorDomain && error._code == 516 {
                        compelete?(filePath, true)
                        return
                    }
                } else {
                    compelete?(filePath, true)
                    return
                }
                
                compelete?(nil, false)
        }
    }

    static func generateRecordAudioFilePath() -> String {
        let audioDirectory = getRecordAudiosFolderPath()
        
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName = "\(timestamp)_录音.aac"
        let audioFilePath = "\(audioDirectory)/\(fileName)"
        return audioFilePath
    }
    
    static func getLocalAudiosFolderPath() -> String {
        let documentDirectory = PGFileHelper.getPingGuoFilePath()
        let audioPath = "\(documentDirectory)/LocalAudios"
        if self.audioFileExists(audioPath) == false {
            do {
                try FileManager.default.createDirectory(atPath: audioPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(audioPath) --- 创建文件夹路径失败 ---")
            }
        }
        return audioPath
    }
    
    static func getRecordAudiosFolderPath() -> String {
        let documentDirectory = PGFileHelper.getPingGuoFilePath()
        let audioPath = "\(documentDirectory)/RecordAudio"
        if self.audioFileExists(audioPath) == false {
            do {
                try FileManager.default.createDirectory(atPath: audioPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(audioPath) --- 创建文件夹路径失败 ---")
            }
        }
        return audioPath
    }
    
    static func getLocalAudioFolderContentFiles() -> [String] {
        var audioFileList: [String] = []
        do {
            audioFileList = try FileManager.default.contentsOfDirectory(atPath: getLocalAudiosFolderPath())
        } catch {
            print("getLocalAudioFolderFiles Error -\(error)")
            return audioFileList
        }
        
        return audioFileList
    }
    
    static func getRecordAudioFolderContentFiles() -> [String] {
        var audioFileList: [String] = []
        do {
            audioFileList = try FileManager.default.subpathsOfDirectory(atPath: getRecordAudiosFolderPath())
        } catch {
            print("getLocalAudioFolderFiles Error -\(error)")
            return audioFileList
        }
        
        return audioFileList
    }
    
    static func deleteAudioFile(at filePath: String) {
        try? FileManager.default.removeItem(atPath: filePath)
    }
}
