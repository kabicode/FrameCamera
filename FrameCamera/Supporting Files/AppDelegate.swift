//
//  AppDelegate.swift
//  FrameCamera
//
//  Created by ShenMu on 2017/5/16.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerShareSDK()
//        setupUmeng()
        return true
    }
    
    //*
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        
//        if let nav = UIApplication.shared.keyWindow?.rootViewController as? BaseNavigationController {
//            return nav.supportedInterfaceOrientations
//        }
//        
//        return [UIInterfaceOrientationMask.portrait]
//    }// */

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return handleAppOpenURLRequest(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return handleAppOpenURLRequest(url)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return handleAppOpenURLRequest(url)
    }
    
    func handleAppOpenURLRequest(_ url: URL) -> Bool {
        guard let scheme = url.scheme else {
            printLog("URL don't have scheme")
            return false
        }
        
        if scheme.hasPrefix("wx") {
            return WXApi.handleOpen(url, delegate: WechatAPIManager.shareManager)
        }
        return false
    }


    // MARK: - ShareSDK
    func registerShareSDK() {
        ShareSDK.registerActivePlatforms([
            SSDKPlatformType.typeWechat.rawValue,
            SSDKPlatformType.typeSinaWeibo.rawValue,
            SSDKPlatformType.typeQQ.rawValue], onImport: { platformType in
                switch platformType {
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.self)
                case SSDKPlatformType.typeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.self)
                case SSDKPlatformType.typeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.self, tencentOAuthClass:TencentOAuth.self)
                default:
                    break
                }
        }, onConfiguration: { platformType, appInfo in
            switch platformType {
            case SSDKPlatformType.typeWechat:
                appInfo?.ssdkSetupWeChat(
                    byAppId: Config.Wechat.appId,
                    appSecret: Config.Wechat.appSecret)
            case SSDKPlatformType.typeSinaWeibo:
                appInfo?.ssdkSetupSinaWeibo(
                    byAppKey: Config.SinaWeibo.appKey,
                    appSecret: Config.SinaWeibo.appSecret,
                    redirectUri: Config.SinaWeibo.redirectUrl,
                    authType:SSDKAuthTypeBoth)
            case SSDKPlatformType.typeQQ:
                appInfo?.ssdkSetupQQ(byAppId: Config.QQ.appId,
                                     appKey: Config.QQ.appKey,
                                     authType: SSDKAuthTypeBoth)
            default:
                break
            }
        })
//        ShareSDK.registerApp(
//            Config.ShareSDK.appKey,
//            activePlatforms: [
//                SSDKPlatformType.typeWechat.rawValue,
//                SSDKPlatformType.typeSinaWeibo.rawValue,
//                SSDKPlatformType.typeQQ.rawValue],
//            onImport: { platformType in
//                switch platformType {
//                case SSDKPlatformType.typeWechat:
//                    ShareSDKConnector.connectWeChat(WXApi.self)
//                case SSDKPlatformType.typeSinaWeibo:
//                    ShareSDKConnector.connectWeibo(WeiboSDK.self)
//                case SSDKPlatformType.typeQQ:
//                    ShareSDKConnector.connectQQ(QQApiInterface.self, tencentOAuthClass:TencentOAuth.self)
//                default:
//                    break
//                }
//        }, onConfiguration: { platformType, appInfo in
//            switch platformType {
//            case SSDKPlatformType.typeWechat:
//                appInfo?.ssdkSetupWeChat(
//                    byAppId: Config.Wechat.appId,
//                    appSecret: Config.Wechat.appSecret)
//            case SSDKPlatformType.typeSinaWeibo:
//                appInfo?.ssdkSetupSinaWeibo(
//                    byAppKey: Config.SinaWeibo.appKey,
//                    appSecret: Config.SinaWeibo.appSecret,
//                    redirectUri: Config.SinaWeibo.redirectUrl,
//                    authType:SSDKAuthTypeBoth)
//            case SSDKPlatformType.typeQQ:
//                appInfo?.ssdkSetupQQ(byAppId: Config.QQ.appId,
//                                     appKey: Config.QQ.appKey,
//                                     authType: SSDKAuthTypeBoth)
//            default:
//                break
//            }
//        })
    }
    
    func setupUmeng() {
//        let manager = PPShareManager.shareInstance()
//        manager?.initShareConfig()
    }
    
}

