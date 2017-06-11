//
//  NSBundle+Language.swift
//  Weike
//
//  Created by yake on 2016/10/18.
//  Copyright © 2016年 Kuaizai. All rights reserved.
//

import Foundation

private let UserLanguageKey = "AppleLanguages"

class BundleEx: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = languageBundle() {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

extension Bundle {
    
    func onLanguage() {
        DispatchQueue.once(token: "com.lizhiweike.token") {
            object_setClass(Bundle.main, BundleEx.self)
        }
    }
    
    func languageBundle() -> Bundle? {
        return Language.standardLanguage.currentBundle
    }
}

class Language: NSObject {
    static let standardLanguage = Language()
    
    fileprivate var language: String?
    var currentBundle: Bundle?
    
    var currentLanguage: String {
        get {
            if language == nil {
                language = (UserDefaults.standard.value(forKey: UserLanguageKey) as! [String])[0]
            }
            return language!
        }
        set {
            guard newValue != language else { return }
            if let path = Bundle.main.path(forResource: newValue, ofType: "lproj"),
                let bundle = Bundle(path: path) {
                language = newValue
                currentBundle = bundle
            } else {
                let infoDict = Bundle.main.infoDictionary! as NSDictionary
                let defaultLanguage = infoDict.value(forKey: kCFBundleDevelopmentRegionKey as String) as! String
                language = defaultLanguage
                let path = Bundle.main.path(forResource: defaultLanguage, ofType: "lproj")!
                currentBundle = Bundle(path: path)
            }
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue([language!], forKey: UserLanguageKey)
            userDefaults.synchronize()
            
            Bundle.main.onLanguage()
        }
    }
}
