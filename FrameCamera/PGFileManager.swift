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
    
    // 生成主目录
    class func getPingGuoFilePath() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let assetDirectory = "\(documentDirectory)/PingGuo"
        let assetFilePath = "\(assetDirectory)"
        if self.fileExists(assetFilePath) == false {
            do {
                try FileManager.default.createDirectory(atPath: assetFilePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(assetFilePath) --- 创建路径失败 ---")
            }
        }
        return assetFilePath
    }
    
    // 生成asset文件夹
    class func generateImageAssetFilePath() -> String {
        let filePath = getPingGuoFilePath()
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp: String = dateFormat.string(from: Date())
        let fileName: String = "imageAsset \(timestamp)"
        let assetFilePath: String = filePath + "/" + fileName
        
        if self.fileExists(assetFilePath) == false {
            do {
                try FileManager.default.createDirectory(atPath: assetFilePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(assetFilePath) --- 创建文件夹失败 ---")
            }
        }
        
        return assetFilePath
    }
    
    // 生成图片名
    class func generateImageFileName(at filePath: String) -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName: String = "\(timestamp)_img.png"
        let imgFilePath: String = filePath + "/" + fileName
        return imgFilePath
    }
    
    class func storeImage(_ image: UIImage, to imageFilePath: String) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
                print("获取照片数据失败")
                return false
        }
        
        if FileManager.default.createFile(atPath: imageFilePath, contents: data, attributes: nil) == false {
            print("\(imageFilePath) ---- 保存照片失败")
            return false
        }

        print("\(imageFilePath) ---- 保存照片成功!!")
        return true;
    }
    
    class func restoreImage(at filePath: String) -> UIImage? {
        guard self.fileExists(filePath) else {
            return nil;
        }
        
        let image = UIImage(contentsOfFile: filePath)
        return image
    }
}
