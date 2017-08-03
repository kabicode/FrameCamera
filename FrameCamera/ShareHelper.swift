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
    func getUploadToken(_ completion:@escaping ((_ token: String) -> ())) {
        let request = Router.Share.getUploadToken
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success:
                guard let value = response.result.value else {
                    showMessageNotifiaction("网络连接错误")
                    return
                }
                
                let json = JSON(value)
                guard let uptoken = json["uptoken"].string else {
                    showMessageNotifiaction("获取上传凭证失败")
                    return
                }
                
                completion(uptoken)
            case .failure:
                showMessageNotifiaction("网络连接错误")
            }
        }
    }
    
    func uploadVideo(_ videoPath: String) {
//        NetworkHelper.uploadRequest(urlPath: "", parameters: [], dataBodyParts: [], showHUD: <#T##Bool#>, hudTip: <#T##String?#>, showError: <#T##Bool#>, errorTip: <#T##String?#>, on: <#T##UIViewController?#>, successHandler: <#T##((JSON) -> Void)?##((JSON) -> Void)?##(JSON) -> Void#>, failureHandler: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
    
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
//
//    }
//
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
        
    }
}
