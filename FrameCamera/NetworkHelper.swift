//
//  NetworkHelper.swift
//  Weike
//
//  Created by yake on 16/8/30.
//  Copyright © 2016年 Kuaizai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MBProgressHUD

typealias DataBodyPart = (data: Data, name: String, fileName: String, mimeType: String)

class NetworkHelper {
    enum NetworkState: String {
        case none = "Unreachable"
        case network2G = "2G"
        case network3G = "3G"
        case network4G = "4G"
        case wifi = "WIFI"
    }
    
    static let networkErrorTip = "网络连接错误"
}

// MARK: - Network Request
extension NetworkHelper {
    
    static func showRequestFailureMessage(_ error: Error, on viewController: UIViewController? = nil) {
        showMessageNotifiaction(networkErrorTip, on: viewController)
    }
    
    /// send network request
    ///
    /// - Parameters:
    ///   - request: request
    ///   - showHUD: viewController is needed if show HUD
    ///   - hudTip: custom hud tip
    ///   - showError: viewController is needed if show error on presented viewController
    ///   - viewController: view controller to show HUD and error message
    ///   - successHandler: success logic
    ///   - failureHandler: failure logic
    static func sendNetworkRequest(
        request: URLRequestConvertible,
        showHUD: Bool = false,
        hudTip: String? = nil,
        showError: Bool = true,
        on viewController: UIViewController? = nil,
        successHandler: ((JSON) -> Void)? = nil,
        failureHandler: (() -> Void)? = nil) {
        
        var hud: MBProgressHUD?
        if showHUD, let controller = viewController {
            hud = MBProgressHUD.showAdded(to: controller.view, animated: true)
            let defaultTip = "加载中..."
            hud?.label.text = hudTip ?? defaultTip
        }
        Alamofire.request(request).responseJSON { response in
            if showHUD {
                hud?.hide(animated: true)
            }
            switch response.result {
            case .success:
                guard let value = response.result.value else {
                    if showError {
                        showMessageNotifiaction(networkErrorTip, on: viewController)
                    }
                    failureHandler?()
                    return
                }
                
                let json = JSON(value)
                let code = json["Code"].intValue
                guard code == 200 else {
                    if showError {
                        let errorMessage = json["Msg"].stringValue
                        showMessageNotifiaction(errorMessage, on: viewController)
                    }
                    failureHandler?()
                    return
                }
                successHandler?(json["Data"])
            case .failure(let error):
                printLog("Error on \("response.request?.url?.absoluteString"): \(error)")
                if showError {
                    showMessageNotifiaction(networkErrorTip, on: viewController)
                }
                failureHandler?()
            }
        }
    }
    
    /// upload request
    ///
    /// - Parameters:
    ///   - urlPath: urlPath
    ///   - parameters: parameters
    ///   - dataBodyParts: dataBodyParts
    ///   - showHUD: viewController is needed if show HUD
    ///   - hudTip: custom hud tip
    ///   - showError: viewController is needed if show error on presented viewController
    ///   - errorTip: custom error tip
    ///   - viewController: view controller to show HUD and error message
    ///   - successHandler: success logic
    ///   - failureHandler: failure logic
    static func uploadRequest(
        urlPath: String,
        parameters: [String: String],
        dataBodyParts: [DataBodyPart],
        showHUD: Bool = true,
        hudTip: String? = nil,
        showError: Bool = true,
        errorTip: String? = nil,
        on viewController: UIViewController? = nil,
        successHandler: ((JSON) -> Void)? = nil,
        failureHandler: (() -> Void)? = nil) {
        
        let urlString = Config.Http.baseURL + urlPath
        let headers: [String: String] = [:]
        
        var hud: MBProgressHUD?
        if showHUD, let controller = viewController {
            hud = MBProgressHUD.showAdded(to: controller.view, animated: true)
            let defaultTip = NSLocalizedString("network.uploadingTip", comment: "Uploading")
            hud?.label.text = hudTip ?? defaultTip
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for bodyPart in dataBodyParts {
                    multipartFormData.append(
                        bodyPart.data,
                        withName: bodyPart.name,
                        fileName: bodyPart.fileName,
                        mimeType: bodyPart.mimeType)
                }
                
                for (key, value) in parameters {
                    if let data = value.data(using: String.Encoding.utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
        },
            to: urlString,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if showHUD {
                            DispatchQueue.main.async {
                                hud?.hide(animated: true)
                            }
                        }
                        switch response.result {
                        case .success:
                            guard let value = response.result.value else {
                                if showError {
                                    let tip = errorTip ?? networkErrorTip
                                    showMessageNotifiaction(tip, on: viewController)
                                }
                                failureHandler?()
                                return
                            }
                            let json = JSON(value)
                            let code = json["Code"].intValue
                            guard code == 200 else {
                                if showError {
                                    let errorTip = json["Msg"].stringValue
                                    showMessageNotifiaction(errorTip, on: viewController)
                                }
                                failureHandler?()
                                return
                            }
                            successHandler?(json)
                        case .failure(let error):
                            printLog("Error to upload: \(error)")
                            if showError {
                                let tip = errorTip ?? networkErrorTip
                                showMessageNotifiaction(tip, on: viewController)
                            }
                            failureHandler?()
                        }
                    }
                case .failure(let encodingError):
                    printLog(encodingError)
                    if showHUD {
                        DispatchQueue.main.async {
                            hud?.hide(animated: true)
                        }
                    }
                    failureHandler?()
                }
        })
    }
    
}
