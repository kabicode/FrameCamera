//
//  PGImage.swift
//  PingGuo
//
//  Created by ShenMu on 2017/6/30.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class PGImage: NSObject, NSCoding {

    // 时长
    var duration: TimeInterval = 0.1

    // 展示图片（优先级 编辑后图片 > 源图）
    var image: UIImage? {
        get {
            if let effect = self.effectImagePath {
                return UIImage(contentsOfFile: PGFileHelper.getSandBoxPath(with: effect))
            }
            else if let originImage = UIImage(contentsOfFile: PGFileHelper.getSandBoxPath(with: imagePath)) {
                return originImage
            }
            
            return nil
        }
    }
    
    var originImage: UIImage? {
        return UIImage(contentsOfFile: PGFileHelper.getSandBoxPath(with: imagePath))
    }
    
    // 展示用图片路径 源图
    var imagePath: String = ""
    
    // 编辑后图片
    var effectImagePath: String?
    
    // 贴图
    var pasters: [Paster] = []
    
    init(_ imagePath: String) {
        self.imagePath = imagePath

//        self.image = PGFileHelper.restoreImage(at: imagePath)
    }
    
//    init?(_ image: UIImage, into filePath: String) {
//        let imagePath = PGFileHelper.generateImageFileName(at: filePath)
//        if PGFileHelper.storeImage(image, to: imagePath) {
//            self.imagePath = imagePath
//            self.image = image
//        }
//        
//        return nil
//    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(imagePath, forKey: "imagePath")
        aCoder.encode(duration, forKey: "duration")
        aCoder.encode(pasters, forKey: "pasters")
        aCoder.encode(effectImagePath, forKey: "effectImagePath")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        imagePath = (aDecoder.decodeObject(forKey: "imagePath") as? String) ?? ""
        effectImagePath = aDecoder.decodeObject(forKey: "effectImagePath") as? String
        duration = aDecoder.decodeDouble(forKey: "duration")
        pasters = (aDecoder.decodeObject(forKey: "pasters") as? [Paster]) ?? []
    }

}
