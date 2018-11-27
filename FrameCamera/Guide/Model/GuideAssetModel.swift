//
//  GuideAssetModel.swift
//  PingGuo
//
//  Created by ShenMu on 2018/11/22.
//  Copyright © 2018 ShenMu. All rights reserved.
//

import UIKit
import SwiftyJSON

class GuideAssetModel: NSObject {
    var id: IntegerLiteralType = 0
    var title: String = ""
    var sortBy: IntegerLiteralType = 0
    var rarKey: String = ""
    var postImage: String = ""
    var createAt: String = ""
    var updateAt: String = ""
    var zipPath: String = ""
    var cachePath: String = ""
    var isDownloaded: Bool = false
    var imageFiles: [String] = []
    
    init(from json: JSON!){
        if json == JSON.null{
            return
        }
        id = json["Id"].intValue
        title = json["Title"].stringValue
        sortBy = json["SortBy"].intValue
        rarKey = json["RarKey"].stringValue
        postImage = json["postimage"].stringValue
        createAt = json["CreateAt"].stringValue
        updateAt = json["UpdateAt"].stringValue
    }
}

//func ==(lhs: GuideAssetModel, rhs: GuideAssetModel) -> Bool {
//    return lhs.id == rhs.id
//}

extension GuideAssetModel {
//    override func isEqual(_ object: Any?) -> Bool {
//        if let asset = object as? PGAsset {
//            return asset.filePath == filePath
//        }
//
//        return false
//    }
//
//    static func ==(lhs: PGAsset, rhs: PGAsset) -> Bool {
//        return lhs.filePath == rhs.filePath
//    }
}
