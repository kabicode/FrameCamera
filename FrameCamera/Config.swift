//
//  Config.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/10.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation

struct Constant {
    static let appName = "品果"
    static let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    static let audioSampleRateDefault = 44100
    static let audioNumberOfChannelDefault = 1
    static let audioBitRateDefault = 64000
    static let videoBitRateDefault = 300 * 1000
    static let videoFrameRateDefault = 10
    
    static let liZhiLiveRoomID = 23715304
    static let liZhiUserAgreementUrl = Config.Http.baseURL + "/account/procotol"
    
    static let cookieRefreshSeconds: Double = 5 * 24 * 60 * 60
    static let loginExpirationSeconds: Double = 7 * 24 * 60 * 60
    
    static let liveVideoSize = CGSize(width: 1280, height: 720)
}

struct Config {
    enum EnvironmentType {
        case debug
        case release
    }
    //    static let environment: EnvironmentType = .debug
    static let environment: EnvironmentType = .release
    
    struct Http {
        private static let debugBaseURL = "http://app.sixiren.com"
        private static let releaseBaseURL = "http://app.sixiren.com"
        
        static var baseURL: String {
            switch environment {
            case .debug:
                return debugBaseURL
            case .release:
                return releaseBaseURL
            }
        }
    }
    
    // MARK: - Platform App Info
    struct Wechat {
        static let appId = "wx2dfce5a1e40bea4c"
        static let appSecret = "72b402517bf01f7242be89982ab75ba2"
    }
    
    struct SinaWeibo {
        static let appKey = "1662874591"
        static let appSecret = "a8b7ad7b98eeda7924fceee47274ed7b"
        static let redirectUrl = "http://www.sixiren.com"
    }
    
    struct QQ {
        static let appId = "1106234299"
        static let appKey = "jLko89VLnjYc6U7E"
    }
    
    struct ShareSDK {
        static let appKey = "2005f389af000"
    }
    
    struct SMSSDK {
        static let appKey = "17cf0ff98d95e"
        static let appSecret = "1e5003c497c159a085ff75042b001f2b"
    }
    
    struct FakeAccount {
        static let zone = "622"
        static let phone = "01142536340"
        static let code = "6340"
    }
    
    struct JPUSH {
        static let appKey = "ed948bd307daf0106c63084d"
    }
    
    struct Umeng {
        static let appKey = "5875a2013eae2534f4002c96"
    }
    
}
