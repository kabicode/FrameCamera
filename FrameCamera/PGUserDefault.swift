//
//  PGUserDefault.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/1.
//  Copyright © 2017年 ShenMu. All rights reserved.
//


struct PGUserDefault {
    static let userDefaults = UserDefaults.standard
    
    // Keys
    static let AssetsArrayKey = "AssetsArrayKey"
    
    
    // Vaule
    static var assetsArray: [PGAsset] {
        get {
            let data = (userDefaults.object(forKey: AssetsArrayKey) as? Data) ?? Data()
            return (NSKeyedUnarchiver.unarchiveObject(with: data) as? [PGAsset]) ?? []
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            userDefaults.set(data, forKey: AssetsArrayKey)
            userDefaults.synchronize()
        }
    }
    
    static func addAsset(_ asset: PGAsset) {
        var assetsArray = self.assetsArray
        assetsArray.append(asset)
        self.assetsArray = assetsArray
    }
    
    static func removeAsset(_ asset: PGAsset) {
        var assetsArray = self.assetsArray
        if let index = assetsArray.index(of: asset) {
            assetsArray.remove(at: index)
            self.assetsArray = assetsArray
        }
    }
    
    static func updateAsset(_ asset: PGAsset) {
        var assetsArray = self.assetsArray
        if let index = assetsArray.index(of: asset) {
            assetsArray[index] = asset
            self.assetsArray = assetsArray
        }
    }
}
