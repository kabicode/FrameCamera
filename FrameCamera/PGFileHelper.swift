//
//  PGFileManager.swift
//  PingGuo
//
//  Created by ShenMu on 2017/6/25.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit
import Alamofire

class PGFileHelper: NSObject {

    static func fileExists(_ filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    static func removeItem(_ folderPath: String) {
        do {
            try FileManager.default.removeItem(at: URL(fileURLWithPath: folderPath))
        } catch {
            printLog("移除文件失败，path:\(folderPath), error:\(error.localizedDescription)")
        }
    }
    
    // MARK: - Chartlets
    // 贴图文件夹
    static func getChartletsFilePath() -> String {
        let documentDirectory = getPingGuoFilePath()
        let chartletPath = "\(documentDirectory)/Chartlets"
        if self.fileExists(chartletPath) == false {
            do {
                try FileManager.default.createDirectory(atPath: chartletPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(chartletPath) --- 创建贴图文件夹路径失败 ---")
            }
        }
        return chartletPath
    }
    
    static func getChartletsFilePathFrom(url: String) -> String {
        let filePath = getChartletsFilePath()
        return filePath + "/" + url
    }
    
    static func downloadChartlet(_ fileURL: String, compelete: ((_ imagePath: String?, _ success: Bool)->())?) {
        let filePath = getChartletsFilePathFrom(url: fileURL)
        if fileExists(filePath) {
            compelete?(filePath, true)
            return
        }
        
        Alamofire.download(fileURL) { _, _ in
            return (URL(fileURLWithPath: filePath), .createIntermediateDirectories)
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
    
    // MARK: - Audios

    // MARK: - Asset Content
    // 生成主目录
    static func getPingGuoFilePath() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let assetDirectory = "\(documentDirectory)/PingGuo"
        let assetFilePath = "\(assetDirectory)"
        if self.fileExists(assetFilePath) == false {
            do {
                try FileManager.default.createDirectory(atPath: assetFilePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(assetFilePath) --- 创建Asset文件夹路径失败 ---")
            }
        }
        return assetFilePath
    }
    
    // 生成asset文件夹
    static func generateImageAssetFilePath() -> String {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp: String = dateFormat.string(from: Date())
        let fileName: String = "imageAsset \(timestamp)"
        let assetFilePath: String = "/" + fileName
        
        let sandBoxPath = self.getSandBoxPath(with: assetFilePath)
        if self.fileExists(sandBoxPath) == false {
            do {
                try FileManager.default.createDirectory(atPath: sandBoxPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("\(assetFilePath) --- 创建文件夹失败 ---")
            }
        }
        
        return assetFilePath
    }
    
    // 获取真实沙盒路径
    static func getSandBoxPath(with assetPath: String) -> String {
        let filePath = getPingGuoFilePath()
        return filePath + assetPath
    }
    
    // 生成图片名
    static func generateImageFileName(at filePath: String) -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName: String = "\(timestamp)_img.png"
        let imgFilePath: String = filePath + "/" + fileName
        return imgFilePath
    }
    
    // 保存图片到沙盒
    static func storeImage(_ image: UIImage, to imagePath: String) -> Bool {
        let imageFilePath = getSandBoxPath(with: imagePath)
        
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
            print("获取照片数据失败")
            return false
        }
        
        do {
            try data.write(to: URL.init(fileURLWithPath: imageFilePath), options: .atomicWrite)
        } catch {
            print("\(imageFilePath) ---- 保存照片失败 --- 主线程\(Thread.isMainThread)")
            return false
        }
        
        print("\(imageFilePath) ---- 保存照片成功!!")
        return true;
    }
    
    // 读取沙盒图片
    static func restoreImage(at imagePath: String) -> UIImage? {
        let filePath = getSandBoxPath(with: imagePath)
        
        guard self.fileExists(filePath) else {
            return nil;
        }
        
        let image = UIImage(contentsOfFile: filePath)
        return image
    }
    
    // 删除沙盒图片
    static func deleteImage(at imagePath: String) -> Bool {
        let filePath = getSandBoxPath(with: imagePath)
        
        do {
            if FileManager.default.fileExists(atPath: filePath) {
                try FileManager.default.removeItem(atPath: filePath)
            }
        } catch {
            print("\(filePath) ---- 删除图片失败")
            return false
        }
        
        print("\(filePath) ---- 删除图片成功!!")
        return true;
    }
}
