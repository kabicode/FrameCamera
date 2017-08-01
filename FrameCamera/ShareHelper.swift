//
//  ShareHelper.swift
//  PingGuo
//
//  Created by ShenMu on 2017/8/1.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation

class ShareHelper {
    func shareWithPlatformType(_ platformType: SSDKPlatformType) {
//        var shareURLString = Config.Http.baseURL
//        var shareDesc = ""
//        if let shareInfo = lecture.shareInfo {
//            shareURLString = shareInfo["share_url"].stringValue
//            shareDesc = shareInfo["share_description"].stringValue
//        }
//        let shareType: SSDKContentType = .auto
//        let desc: String = shareDesc
//        
//        let imageData = ImageHelper.scaleImage(posterImage, maximumSize: 32)!
//        let image: UIImage
//        if imageData.count > 32 * 1024 {
//            image = UIImage(named: "ShareImage")!
//        } else {
//            image = UIImage(data: imageData)!
//        }
//        
//        let shareParameters = NSMutableDictionary()
//        if platformType == .subTypeWechatSession ||
//            platformType == .subTypeWechatTimeline {
//            shareParameters.ssdkSetupWeChatParams(
//                byText: desc,
//                title: lecture.name,
//                url: URL(string: shareURLString),
//                thumbImage: image,
//                image: image,
//                musicFileURL: nil,
//                extInfo: nil,
//                fileData: nil,
//                emoticonData: nil,
//                type: shareType,
//                forPlatformSubType: platformType)
//        }
//        
//        if platformType == .typeSinaWeibo {
//            let text = "\(desc)"
//            shareParameters.ssdkSetupSinaWeiboShareParams(
//                byText: text,
//                title: lecture.name,
//                image: image,
//                url: URL(string: shareURLString),
//                latitude: 0,
//                longitude: 0,
//                objectID: "",
//                type: SSDKContentType.auto)
//            shareParameters.ssdkEnableUseClientShare()
//        }
//        
//        ShareSDK.share(platformType, parameters: shareParameters) { (state, parameters, entity, error) in
//            switch state {
//            case .success:
//                let title = NSLocalizedString("share.successToShareTip", comment: "Success to Share Tip")
//                showToast(title)
//            case .fail:
//                let title = NSLocalizedString("share.failToShareTip", comment: "Fail to Share Tip")
//                showToast(title)
//                printLog("\(String(describing: error))")
//            default:
//                break
//            }
//        }
        
    }
}
