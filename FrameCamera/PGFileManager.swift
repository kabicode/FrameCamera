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
    
    class func getImageAssetFilePath() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let assetDirectory = "\(documentDirectory)/imageAsset"
        let assetFilePath = "\(assetDirectory)"
        if self.fileExists(assetFilePath) == false {
            do {
                try FileManager.default.createDirectory(atPath: assetFilePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(assetFilePath) --- 创建路径成功 ---")
            }
            
        }
        return assetFilePath
    }
    
    class func generateImageFileName(at filePath: String) -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName: String = "\(timestamp)_img.png"
        let imgFilePath: String = filePath + "/" + fileName
        return imgFilePath
    }
    
    
    class func storeImage(_ image: UIImage, toImageAsset: String) -> URL? {
        let imageFilePath = self.generateImageFileName(at: toImageAsset)
        
        guard let data = UIImageJPEGRepresentation(image, 1.0),
            let url = URL(string: imageFilePath) else {
                print("保存照片失败")
                return nil
        }
        
        
        do {
           try data.write(to: url)
        }
        catch {
            print("\(imageFilePath) ---- 保存照片失败")
            return nil
        }

        print("\(imageFilePath) ---- 保存照片成功!!")
        return url;
    }
    
    class func restoreImage(at filePath: String) -> UIImage? {
        guard self.fileExists(filePath) else {
            return nil;
        }
        
        let image = UIImage(contentsOfFile: filePath)
        return image
    }
}
