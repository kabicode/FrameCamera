//
//  CropBgImage.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/16.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import SwiftyJSON

class CropBgImage : NSObject {
    
    var createAt : String?
    var dType : Int = 0
    var id : Int = 0
    var size : String?
    var sortBy : Int = 0
    var thumbUrl : String?
    var title : String?
    var updateAt : String?
    var url : String = ""
    var version : Int = 0
    var image: UIImage?
    
    override init() {
        super.init()
    }
    
    init(from json: JSON!){
        if json == JSON.null{
            return
        }
        createAt = json["CreateAt"].stringValue
        dType = json["DType"].intValue
        id = json["Id"].intValue
        size = json["Size"].stringValue
        sortBy = json["SortBy"].intValue
        thumbUrl = json["Thumb_url"].stringValue
        title = json["Title"].stringValue
        updateAt = json["UpdateAt"].stringValue
        url = json["Url"].stringValue
        version = json["Version"].intValue
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? CropBgImage {
            return self.url == object.url
        }
        return false
    }
}
