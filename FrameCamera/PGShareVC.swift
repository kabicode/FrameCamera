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

class PGShareViewController: BaseViewController {
    
    enum ShareType {
        case appStore
        case video
    }
    
    @IBOutlet weak var wechatShareBtn: UIButton!
    @IBOutlet weak var qqShareBtn: UIButton!
    @IBOutlet weak var sinaShareBtn: UIButton!
    
    var asset: PGAsset!
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
                ShareHelper.shareWithPlatformType(platform, shareURLString: url)
                self?.dismissVC()
            }
        } else {
//            ShareHelper.shareWithPlatformType(platform, shareURLString: url)
        }
    }
    
    func uploadVideo(completion: @escaping ((_ url: String) -> ())) {
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        ShareHelper.getUploadToken {[weak self, weak hud] (token) in
            hud?.hide(animated: true)
            
            guard let token = token else {
                showMessageNotifiaction("网络错误")
                return
            }
            
            guard let videoPath = self?.asset.videoPath else {
                showMessageNotifiaction("视频文件路径错误")
                return
            }
            
            let filePath = PGFileHelper.getSandBoxPath(with: videoPath)
            
            let components = videoPath.components(separatedBy: "/")
            let key = components.last ?? "Empty"
            
            hud?.label.text = "上传中"
            hud?.show(animated: true)
            let manager = QNUploadManager()
            manager?.putFile(filePath, key: key, token: token, complete: { (info, key, resp) in
                hud?.hide(animated: true)
                
                print("\(String(describing: resp))", "\(String(describing: info?.statusCode))", "\(String(describing: info?.error))")
                
                let url = "http://" + info!.host + "/" + key!
                let request = Router.Share.uploadVideoPath(videoPath: url, title: key!)
                NetworkHelper.sendNetworkRequest(request: request, showHUD: true, hudTip: "上传中", successHandler: { (json) in
                    print("\(json)")
                    let url = json["Url"].stringValue
                    completion(url)
                    
                }, failureHandler: nil)
                
            }, option: nil)
        }

    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
