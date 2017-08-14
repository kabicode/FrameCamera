//
//  ShareHelper.swift
//  PingGuo
//
//  Created by ShenMu on 2017/8/1.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ShareHelper {
    static func getUploadToken(_ completion:@escaping ((_ token: String?) -> ())) {
        let request = Router.Share.getUploadToken
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success:
                guard let value = response.result.value else {
                    completion(nil)
                    showMessageNotifiaction("网络连接错误")
                    return
                }
                
                let json = JSON(value)
                guard let uptoken = json["uptoken"].string else {
                    completion(nil)
                    showMessageNotifiaction("获取上传凭证失败")
                    return
                }
                
                completion(uptoken)
            case .failure:
                completion(nil)
                showMessageNotifiaction("网络连接错误")
            }
        }
    }
    
    static func shareWithPlatformType(_ platformType: SSDKPlatformType, shareURLString: String) {
        let shareDesc = "品果视频分享"
        let title = "品果视频"
        let shareType: SSDKContentType = .auto
        let desc: String = shareDesc
        let image = UIImage(named:"ShareAppIcon")

        let shareParameters = NSMutableDictionary()
        if platformType == .subTypeWechatSession ||
            platformType == .subTypeWechatTimeline {
            shareParameters.ssdkSetupWeChatParams(
                byText: desc,
                title: title,
                url: URL(string: shareURLString),
                thumbImage: image,
                image: image,
                musicFileURL: nil,
                extInfo: nil,
                fileData: nil,
                emoticonData: nil,
                type: shareType,
                forPlatformSubType: platformType)
        }

        if platformType == .typeSinaWeibo {
            let text = "\(desc)"
            shareParameters.ssdkSetupSinaWeiboShareParams(
                byText: text,
                title: title,
                image: image,
                url: URL(string: shareURLString),
                latitude: 0,
                longitude: 0,
                objectID: "",
                type: SSDKContentType.auto)
            shareParameters.ssdkEnableUseClientShare()
        }
        
        if platformType == .typeQQ {
            let text = desc
            shareParameters.ssdkSetupQQParams(
                byText: text,
                title: title,
                url: URL(string: shareURLString),
                thumbImage: image,
                image: image,
                type: .auto,
                forPlatformSubType: .subTypeQQFriend)
        }

        ShareSDK.share(platformType, parameters: shareParameters) { (state, parameters, entity, error) in
            switch state {
            case .success:
                let title = "分享成功"
                showMessageNotifiaction(title, type: .success, on: nil)
            case .fail:
                let title = "分享失败"
                showToast(title)
                printLog("\(String(describing: error))")
            default:
                break
            }
        }

    }

//    func checkLecturePush() {
//        let request = Router.Lecture.checkLecturePush(lectureId: lecture.id)
//        NetworkHelper.sendNetworkRequest(
//            request: request,
//            showHUD: true,
//            on: self,
//            successHandler: { (json) in
//                let canPush = json["data"]["can_push"].boolValue
//                let pushTime = json["data"]["push_time"].intValue
//                let pushMessage = json["data"]["msg"].stringValue
//                let pushFormat = LectureDetailLocalizedString("lectureDetail.pushChannel.remainingPushTime", comment: "Remaining push time")
//                let pushTimeTip = String(format: pushFormat, pushTime)
//                if !canPush {
//                    let alert = UIAlertController.okAlert(
//                        title: pushMessage,
//                        message: pushTimeTip)
//                    self.present(alert, animated: true, completion: nil)
//                } else {
//                    let actionTitle = LectureDetailLocalizedString("lectureDetail.pushChannel.pushAction", comment: "Push")
//                    let alert = UIAlertController.alert(
//                        title: pushMessage,
//                        message: pushTimeTip,
//                        actionTitle: actionTitle) { (action) in
//                            self.pushLecture()
//                    }
//                    self.present(alert, animated: true, completion: nil)
//                }
//        })
        
//    }
}
