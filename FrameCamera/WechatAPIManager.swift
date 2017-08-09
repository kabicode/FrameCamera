//
//  WechatAPIManager.swift
//  Weike
//
//  Created by yake on 16/8/26.
//  Copyright © 2016年 Kuaizai. All rights reserved.
//

import Foundation

protocol WechatAPIManagerDelegate: class {
    func managerDidReceivePayResponse(_ success: Bool)
}

class WechatAPIManager: NSObject, WXApiDelegate {
    static let shareManager = WechatAPIManager()
    
    weak var delegate: WechatAPIManagerDelegate?
    
    @objc func onResp(_ response: BaseResp!) {
        if response.isKind(of: PayResp.self) {
            switch response.errCode {
            case WXSuccess.rawValue:
                printLog("Success to pay: \(response.errCode)")
                delegate?.managerDidReceivePayResponse(true)
            default:
                printLog("Error to pay: \(response.errCode), \(response.errStr)")
                delegate?.managerDidReceivePayResponse(false)
            }
        }
    }
    
    // text
    class func shareText(_ text: String, inScene scene: WXScene) -> Bool {
        let request = SendMessageToWXReq()
        request.text = text
        request.bText = true
        request.scene = Int32(scene.rawValue)
        
        return WXApi.send(request)
    }
    
    // music
    class func shareMusicWithTitle(_ title: String, description: String, thumbImage: UIImage, musicUrl: String, musicDataUrl: String, inScene scene: WXScene) -> Bool {
        let message = WXMediaMessage()
        message.title = title
        message.description = description
        message.setThumbImage(thumbImage)
        
        let music = WXMusicObject()
        music.musicUrl = musicUrl
        music.musicDataUrl = musicDataUrl
        message.mediaObject = music
        
        let request = SendMessageToWXReq()
        request.message = message
        request.bText = false
        request.scene = Int32(scene.rawValue)
        
        return WXApi.send(request)
    }
    
    // video
    class func shareVideoWithTitle(_ title: String, description: String, thumbImage: UIImage, url: String, inScene scene: WXScene) -> Bool {
        let message = WXMediaMessage()
        message.title = title
        message.description = description
        message.setThumbImage(thumbImage)
        
        let video = WXVideoObject()
        video.videoUrl = url
        message.mediaObject = video
        
        let request = SendMessageToWXReq()
        request.message = message
        request.bText = false
        request.scene = Int32(scene.rawValue)
        
        return WXApi.send(request)
    }

}
