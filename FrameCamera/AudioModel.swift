//
//  OnlineAudioModel.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/16.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import SwiftyJSON

class AudioModel : NSObject, NSCoding{
    
    var createAt : String?
    var id : Int = 0
    var size : String?
    var sortBy : Int = 0
    var updateAt : String = ""
    var version : Int = 0
    
    var title : String = ""
    var url : String = ""
    var filePath : String?
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    override init() {
        super.init()
    }
    
    // 沙盒路径
    init(audioFilePath: String) {
        title = PGAudioFileHelper.getFileNameFromURL(audioFilePath)
        url = audioFilePath
        filePath = PGAudioFileHelper.getAuidoFilePathFromSandBoxPath(audioFilePath)
    }
    
    init(from json: JSON){
        if json == JSON.null{
            return
        }
        
        createAt = json["CreateAt"].stringValue
        id = json["Id"].intValue
        size = json["Size"].stringValue
        sortBy = json["SortBy"].intValue
        title = json["Title"].stringValue
        updateAt = json["UpdateAt"].stringValue
        url = json["Url"].stringValue
        version = json["Version"].intValue
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: "url")
        aCoder.encode(title, forKey: "Title")
        aCoder.encode(filePath, forKey: "filePath")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        url = aDecoder.decodeObject(forKey: "url") as! String
        title = aDecoder.decodeObject(forKey: "Title") as! String
        filePath = aDecoder.decodeObject(forKey: "filePath") as! String
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? AudioModel {
            return (self.url == object.url) && (self.title == object.title)
        }
        return false
    }
}
