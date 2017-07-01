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
    var duration: TimeInterval = 1.0

    // 图片
    var image: UIImage?
    
    // 图片路径
    var imagePath: String
    
    // 沙盒图片路径
    var sandboxPath: String {
        get {
            return PGFileHelper.getSandBoxPath(with: imagePath)
        }
    }
    
    init(_ imagePath: String) {
        self.imagePath = imagePath
        self.image = PGFileHelper.restoreImage(at: imagePath)
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
    }
    
    public required init?(coder aDecoder: NSCoder) {
        imagePath = aDecoder.decodeObject(forKey: "imagePath") as! String
        duration = aDecoder.decodeDouble(forKey: "duration")
    }

}
