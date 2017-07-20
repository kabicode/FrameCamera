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
    static let GreenCropEnableKey = "GreenCropEnableKey"
    static let DoubleImageEnableKey = "DoubleImageEnableKey"
    static let GriddingEnableKey = "GriddingEnableKey"
    static let AssetsArrayKey = "AssetsArrayKey"
    static let LocalAudioArrayKey = "LocalAudioArrayKey"
    static let RecordAudioArrayKey = "RecordAudioArrayKey"
    
    // camera setting key
    static var greenCropEnable: Bool {
        set {
            userDefaults.set(newValue, forKey: GreenCropEnableKey)
            userDefaults.synchronize()
        }
        get {
            return userDefaults.value(forKey: GreenCropEnableKey) as? Bool ?? true
        }
    }
    
    static var doubleImageEnable: Bool {
        set {
            userDefaults.set(newValue, forKey: DoubleImageEnableKey)
            userDefaults.synchronize()
        }
        get {
            return userDefaults.value(forKey: DoubleImageEnableKey) as? Bool ?? true
        }
    }
    static var griddingEnable: Bool {
        set {
            userDefaults.set(newValue, forKey: GriddingEnableKey)
            userDefaults.synchronize()
        }
        get {
            return userDefaults.value(forKey: GriddingEnableKey) as? Bool ?? true
        }
    }
    
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
        if assetsArray.count > 0 {
            assetsArray.insert(asset, at: 0)
        } else {
            assetsArray.append(asset)
        }
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
    
    
    // localAudios
    static var localAudios: [AudioModel] {
        get {
            let data = (userDefaults.object(forKey: LocalAudioArrayKey) as? Data) ?? Data()
            return (NSKeyedUnarchiver.unarchiveObject(with: data) as? [AudioModel]) ?? []
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            userDefaults.set(data, forKey: LocalAudioArrayKey)
            userDefaults.synchronize()
        }
    }
    
    static func addLocalAudio(_ audio: AudioModel) {
        var localAudios = self.localAudios
        if localAudios.count > 0 {
            localAudios.insert(audio, at: 0)
        } else {
            localAudios.append(audio)
        }
        self.localAudios = localAudios
    }
    
    // recordAudios
    static var recordAudios: [AudioModel] {
        get {
            let data = (userDefaults.object(forKey: RecordAudioArrayKey) as? Data) ?? Data()
            return (NSKeyedUnarchiver.unarchiveObject(with: data) as? [AudioModel]) ?? []
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            userDefaults.set(data, forKey: RecordAudioArrayKey)
            userDefaults.synchronize()
        }
    }
    
    static func addRecordAudio(with audioPath: String) {
        var recordAudios = self.recordAudios
        let audio = AudioModel(audioFilePath: audioPath)
        
        if !recordAudios.contains(audio) {
            if recordAudios.count > 0 {
                recordAudios.insert(audio, at: 0)
            } else {
                recordAudios.append(audio)
            }
            self.recordAudios = recordAudios
        }
    }
    
}
