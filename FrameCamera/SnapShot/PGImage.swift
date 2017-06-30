//
//  PGImage.swift
//  PingGuo
//
//  Created by ShenMu on 2017/6/30.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class PGImage: NSObject {

    // 时长
    var duration: TimeInterval = 1.0

    // 图片
    var image: UIImage
    
    // 图片路径
    var imagePath: String
    
    init(_ image: UIImage, _ imagePath: String) {
        self.image = image
        self.imagePath = imagePath
    }
}
