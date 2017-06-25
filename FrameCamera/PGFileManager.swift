//
//  PGFileManager.swift
//  PingGuo
//
//  Created by ShenMu on 2017/6/25.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class PGFileHelper: NSObject {

    class func fileExists(_ filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    class func generateImageAssetFilePath() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let assetDirectory = "\(documentDirectory)/imageAsset"
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName = "\(timestamp).png"
        let assetFilePath = "\(assetDirectory)/\(fileName)"
        return assetFilePath
    }
    
    
}
