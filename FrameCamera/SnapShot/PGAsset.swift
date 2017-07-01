//
//  PGAsset.swift
//  PingGuo
//
//  Created by ShenMu on 2017/6/30.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class PGAsset: NSObject {

    var filePath: String
    
    var imageList: [PGImage] = []
    
    var posterImage: URL?
    
    var video: URL?
    
    // 总时间
    var duration: TimeInterval = 0.0
    
    
    init(filePath: String) {
        self.filePath = filePath
    }
    
    // MARK: - Public Method
    func add(_ image: UIImage) -> PGImage? {
        let imagePath = PGFileHelper.generateImageFileName(at: filePath)
        if PGFileHelper.storeImage(image, to: imagePath) {
            let pgImage = PGImage(image, imagePath)
            imageList.append(pgImage)
            return pgImage
        }
        
        return nil;
    }
}
