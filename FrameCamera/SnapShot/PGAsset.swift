//
//  PGAsset.swift
//  PingGuo
//
//  Created by ShenMu on 2017/6/30.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class PGAsset: NSObject, NSCoding {

    var filePath: String
    
    var imageList: [PGImage] = []
    // 封面
    var posterImage: URL?
    // 初始视频
    var videoPath: String?
    // 音频
    var audioPath: String?
    
    // 总时间
    var duration: TimeInterval = 0.0
    
    // 沙盒图片路径
    var sandboxPath: String {
        get {
            return PGFileHelper.getSandBoxPath(with: filePath)
        }
    }
    
    // 源视频路径
    var originVideoUrl: URL? {
        if let videoPath = self.videoPath {
            return URL(fileURLWithPath: PGFileHelper.getSandBoxPath(with: videoPath))
        }
        return nil
    }
    
    init(filePath: String) {
        self.filePath = filePath
    }
    
    
    // MARK: - Public Method
    func add(_ image: UIImage, at index: Int? = nil) -> PGImage? {
        let imagePath = PGFileHelper.generateImageFileName(at: filePath)
        
        if PGFileHelper.storeImage(image, to: imagePath) {
            let pgImage = PGImage(imagePath)
            
            if let insertIndex = index, insertIndex < imageList.count - 1 {
                imageList.insert(pgImage, at: insertIndex)
            } else {
                imageList.append(pgImage)
            }

            if posterImage == nil && imageList.count > 0 {
                posterImage = URL(fileURLWithPath: imageList[0].sandboxPath)
            }
            
            PGUserDefault.updateAsset(self)
            return pgImage
        }
        
        return nil;
    }
    
    
    func delete(_ pgImage: PGImage) -> PGImage? {
        if let index = imageList.index(of: pgImage) {
            
            let _ = PGFileHelper.deleteImage(at: pgImage.imagePath)
            imageList.remove(at: index)
            
            if imageList.count > 0 {
                posterImage = URL(fileURLWithPath: imageList[0].sandboxPath)
            }
            
            PGUserDefault.updateAsset(self)
            return pgImage
        }
        return nil
    }
    
    
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(filePath, forKey: "filePath")
        aCoder.encode(imageList, forKey: "imageList")
        if (posterImage != nil) {
            aCoder.encode(posterImage, forKey: "posterImage")
        }
        if (videoPath != nil) {
            aCoder.encode(videoPath, forKey: "videoPath")
        }
        if audioPath != nil {
            aCoder.encode(audioPath, forKey: "audioPath")
        }
        aCoder.encode(duration, forKey: "duration")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        filePath = aDecoder.decodeObject(forKey: "filePath") as! String
        imageList = aDecoder.decodeObject(forKey: "imageList") as! [PGImage]
        posterImage = aDecoder.decodeObject(forKey: "posterImage") as? URL
        videoPath = aDecoder.decodeObject(forKey: "videoPath") as? String
        duration = aDecoder.decodeDouble(forKey: "duration")
        audioPath = aDecoder.decodeObject(forKey: "audioPath") as? String
    }
}

func ==(lhs: PGAsset, rhs: PGAsset) -> Bool {
    return lhs.filePath == rhs.filePath
}

extension PGAsset {
    override func isEqual(_ object: Any?) -> Bool {
        if let asset = object as? PGAsset {
            return asset.filePath == filePath
        }
        
        return false
    }
    
    static func ==(lhs: PGAsset, rhs: PGAsset) -> Bool {
        return lhs.filePath == rhs.filePath
    }
}
