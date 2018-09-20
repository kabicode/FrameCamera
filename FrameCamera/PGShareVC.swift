//
//  PGShareViewController.swift
//  PingGuo
//
//  Created by ShenMu on 2017/8/3.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit
import Qiniu
import MBProgressHUD
import SwiftyJSON

class PGShareViewController: BaseViewController {
    
    enum ShareType {
        case app
        case video
    }
    
    @IBOutlet weak var wechatShareBtn: UIButton!
    @IBOutlet weak var qqShareBtn: UIButton!
    @IBOutlet weak var sinaShareBtn: UIButton!
    
    var asset: PGAsset?
    var shareType: ShareType = .video
    
    static func loadFromStoryboard() -> PGShareViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PGShareViewController") as! PGShareViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        sinaShareBtn.isHidden = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissVC))
        view.addGestureRecognizer(tap)
    }

    @IBAction func tapWechatShare(_ sender: Any) {
        shareTo(platform: .subTypeWechatSession)
    }
    
    @IBAction func tapQQShare(_ sender: Any) {
        shareTo(platform: .typeQQ)
    }
    
    @IBAction func tapSinaShare(_ sender: Any) {
        shareTo(platform: .typeSinaWeibo)
    }
    
    // MARK: - Private Method
    func shareTo(platform: SSDKPlatformType) {
        if shareType == .video {
            uploadVideo { [weak self] (url) in
                ShareHelper.shareWithPlatformType(platform,
                                                  title:"品果视频",
                                                  shareDesc:"品果视频分享",
                                                  shareURLString: url)
                self?.dismissVC()
            }
        } else {
            ShareHelper.shareWithPlatformType(platform,
                                              title:"我在用品果定格动画App",
                                              shareDesc:"快下载来玩一下。",
                                              shareURLString: Config.Http.baseURL + "/?from=groupmessage&isappinstalled=0")
            self.dismissVC()
        }
    }
    
    func uploadVideo(completion: @escaping ((_ url: String) -> ())) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        ShareHelper.getUploadToken {[weak self, weak hud] (token) in
            hud?.hide(animated: true)
            
            if self == nil {
                return
            }
            
            guard let token = token else {
                showMessageNotifiaction("网络错误")
                return
            }
            
            guard let videoPath = self?.asset?.videoSandBoxPath else {
                showMessageNotifiaction("视频文件路径错误")
                return
            }
            
            let filePath = videoPath
            
            hud?.label.text = "上传中"
            hud?.show(animated: true)
            let manager = QNUploadManager()
            manager?.putFile(filePath, key: nil, token: token, complete: { (info, key, resp) in
                hud?.hide(animated: true)
                
                if self == nil {
                    return
                }
                
                print("\(String(describing: resp))", "\(String(describing: info?.statusCode))", "\(String(describing: info?.error))")
                
                let key = (resp?["key"] as? String) ?? ""
                let request = Router.Share.uploadQiNiuKey(key)
                NetworkHelper.sendNetworkRequest(request: request, showHUD: true, hudTip: "上传中", successHandler: { (json) in
                    print("\(json)")
                    let url = json["Url"].stringValue
                    completion(url)
                    
                }, failureHandler: { _ in
                    showToast("视频上传失败")
                })
                
            }, option: nil)
        }

    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
