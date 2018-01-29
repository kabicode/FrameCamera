//
//  PGVideoManager.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/6.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import CoreVideo
import CoreMedia
import AssetsLibrary
import AVFoundation

typealias PGVideoMakeCompletion = ((_ url: URL, _ duration: Double) -> Void)
typealias PGVideoSyncthesizeCompletion = ((_ url: URL?, _ success: Bool) -> Void)
typealias PGVideoMixVideoCompletion = ((_ mixVideoPath: String?, _ url: URL?, _ success: Bool) -> Void)

class PGVideoHelper: NSObject {
    
    static var fps: Int32 = 10
    
    // 生成视频名
    static func generateVideoFileName(at filePath: String) -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName: String = "\(timestamp)_video.mp4"
        let imgFilePath: String = filePath + "/" + fileName
        return imgFilePath
    }
    
    //MARK: Public methods
    static func generousOriginMovie(from asset: PGAsset, completionBlock:@escaping PGVideoMakeCompletion) {
        if let videoPath = asset.videoPath {
            DispatchQueue.main.async {
                let sandboxPath = PGFileHelper.getSandBoxPath(with: videoPath)
                if PGFileHelper.fileExists(sandboxPath) {
                    asset.videoPath = nil
                    PGFileHelper.removeItem(sandboxPath)
                }
            }
        }
        
        let videoPath = PGVideoHelper.generateVideoFileName(at: asset.filePath)
        let sandboxPath = PGFileHelper.getSandBoxPath(with: videoPath)
        
        PGVideoHelper.createMovie(videoPath: sandboxPath, pgImages: asset.imageList) { (fileURL, duration) in
            asset.videoPath = videoPath
            asset.duration = duration
            
            PGUserDefault.updateAsset(asset)
            let time = DispatchTime.now() + 1.0
            DispatchQueue.main.asyncAfter(deadline: time, execute: { 
                completionBlock(fileURL, duration)
            })
        }
    }
    
    static func createMovie(videoPath: String, pgImages: [PGImage], completionBlock: @escaping PGVideoMakeCompletion){
        
        var tempPath:String
        tempPath = videoPath
//        repeat{
//            tempPath = videoPath
//        }while(FileManager.default.fileExists(atPath: videoPath))
        
        let fileURL = URL(fileURLWithPath: tempPath)
        let assetWriter = try! AVAssetWriter(url: fileURL, fileType: AVFileTypeQuickTimeMovie)
        
        guard let size = pgImages.first?.image?.size else {
            print("Empty Iamge List")
            return
        }
        
        let videoSettings:[String: Any] = [AVVideoCodecKey: AVVideoCodecJPEG,
                                           AVVideoWidthKey: Int(size.width),
                                           AVVideoHeightKey: Int(size.height)]
        
        let writeInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoSettings)
        assert(assetWriter.canAdd(writeInput), "add failed")
        
        assetWriter.add(writeInput)
        let bufferAttributes:[String: Any] = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB)]
        let bufferAdapter = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writeInput, sourcePixelBufferAttributes: bufferAttributes)
        
        assetWriter.startWriting()
        assetWriter.startSession(atSourceTime: kCMTimeZero)
        
        let mediaInputQueue = DispatchQueue(label: "mediaInputQueue")
        var imageIndex = 0
        var lastTime = CMTimeMake(Int64(0), fps)
        
        writeInput.requestMediaDataWhenReady(on: mediaInputQueue){
            
            while true {
                if imageIndex >= pgImages.count {
                    break
                }
                
                if writeInput.isReadyForMoreMediaData {
                    
                    var sampleBuffer:CVPixelBuffer?
                    autoreleasepool{
                        if let img = pgImages[imageIndex].image {
                            sampleBuffer = newPixelBufferFrom(cgImage: img.cgImage!)
                        } else {
                            imageIndex += 1
                            print("Warning: counld not extract one of the frames")
                            //                            continue
                        }
                    }
                    
                    if (sampleBuffer != nil){
                        let pgImage = pgImages[imageIndex];
                        let frameCount = Int64(pgImage.duration * TimeInterval(fps))
                        
                        for i in 0..<frameCount {
                            let cmTime = CMTimeMake(i, fps)
                            let presentTime = CMTimeAdd(lastTime, cmTime)
                            while (writeInput.isReadyForMoreMediaData == false) {}
                            bufferAdapter.append(sampleBuffer!, withPresentationTime: presentTime)
                        }
                        let presentTime = CMTimeMake(frameCount, fps)
                        lastTime = CMTimeAdd(lastTime, presentTime)
                        imageIndex = imageIndex + 1
                        
                        //                        if imageIndex > 0 {
                        //                            let pgImage = pgImages[imageIndex - 1]
                        //                            let presentTime = CMTimeMake(Int64(pgImage.duration * TimeInterval(fps)), fps)
                        //                            lastTime = CMTimeAdd(lastTime, presentTime)
                        //                        }
                        //
                        //                        bufferAdapter.append(sampleBuffer!, withPresentationTime: lastTime)
                        //                        imageIndex = imageIndex + 1
                    }
                }
            }
            
            writeInput.markAsFinished()
            assetWriter.finishWriting {
                DispatchQueue.main.sync {
                    let video = AVURLAsset(url: fileURL)
                    print("duration: \(video.duration.seconds)")
                    print(fileURL.absoluteString)
                    completionBlock(fileURL, video.duration.seconds)
                }
            }
        }
    }
    
    
    static func generousMixVideo(from asset: PGAsset, completionBlock:@escaping PGVideoMixVideoCompletion) {
        
        let exportPath = asset.mixVideoPath ?? PGVideoHelper.generateVideoFileName(at: asset.filePath)
        let sandboxPath = PGFileHelper.getSandBoxPath(with: exportPath)
        if PGFileHelper.fileExists(sandboxPath) {
            PGFileHelper.removeItem(sandboxPath)
        }
        
        let exportURL = URL(fileURLWithPath: sandboxPath)
        guard let videoPath = asset.videoPath else {
            printLog("源视频不存在")
            completionBlock(nil, nil, false)
            return
        }
        
        guard let audioPath = asset.audio?.filePath else {
            printLog("不存在音频文件")
            completionBlock(nil, nil, true)
            return
        }
        
        let videoURL = URL(fileURLWithPath: PGFileHelper.getSandBoxPath(with: videoPath))
        let audioURL = URL(fileURLWithPath: PGFileHelper.getSandBoxPath(with: audioPath))
        self.synthesizeVideo(videoPath: videoURL, audioPath: audioURL, exportPath: exportURL, completionBlock: { (url, success) in
            DispatchQueue.main.async {
                completionBlock(exportPath, exportURL, success)
            }
        })
    }
    
    static func synthesizeVideo(videoPath: URL, audioPath: URL, exportPath:URL, completionBlock: @escaping PGVideoSyncthesizeCompletion) {
        let videoAsset = AVAsset(url: videoPath)
        let audioAsset = AVAsset(url: audioPath)
        
        guard let videoAssetTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo).first,
            let audioAssetTrack = audioAsset.tracks(withMediaType: AVMediaTypeAudio).first else {
                completionBlock(nil, false)
                return
        }
        
        do {
            let composition = AVMutableComposition()
            let videoCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
            try videoCompositionTrack.insertTimeRange(CMTimeRange.init(start: kCMTimeZero, end: videoAssetTrack.timeRange.duration), of: videoAssetTrack, at: kCMTimeZero)
            
            let audioCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            try audioCompositionTrack.insertTimeRange(CMTimeRange.init(start: kCMTimeZero, end: videoAssetTrack.timeRange.duration), of: audioAssetTrack, at: kCMTimeZero)
            
            // 是否加入视频原声
//            let originAudioAssetTrack = videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0]
//            let originalAudioCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//            try originAudioAssetTrack.insertTimeRange(CMTimeRange.init(start: kCMTimeZero, end: originAudioAssetTrack.timeRange.duration), of: originAudioAssetTrack, at: kCMTimeZero)
            
            // 导出素材
            guard let exporter = AVAssetExportSession.init(asset: composition, presetName: AVAssetExportPresetMediumQuality) else {
                completionBlock(exportPath, false)
                return
            }
            
            // 音量控制
            
            // 设置输出路径
            exporter.outputURL = exportPath
            exporter.outputFileType = AVFileTypeMPEG4
            exporter.shouldOptimizeForNetworkUse = true
            
            exporter.exportAsynchronously(completionHandler: {
                switch exporter.status {
                case .completed:
                    completionBlock(exportPath, true)
                case .failed:
                    printLog("合成失败, error -- \(String(describing: exporter.error))")
                    completionBlock(exportPath, false)
                default:
                    printLog("合成失败, error -- \(String(describing: exporter.error))")
                    completionBlock(exportPath, false)
                }
            })
        } catch {
            completionBlock(exportPath, false)
            printLog("合成视频失败，error -- \(error)")
            return
        }
    }
    
    //MARK: Private methods
    private static func newPixelBufferFrom(cgImage:CGImage) -> CVPixelBuffer?{
        let options:[String: Any] = [kCVPixelBufferCGImageCompatibilityKey as String: true, kCVPixelBufferCGBitmapContextCompatibilityKey as String: true]
        var pxbuffer:CVPixelBuffer?
        let frameWidth = cgImage.width
        let frameHeight = cgImage.height
        
        let status = CVPixelBufferCreate(kCFAllocatorDefault, frameWidth, frameHeight, kCVPixelFormatType_32ARGB, options as CFDictionary?, &pxbuffer)
        assert(status == kCVReturnSuccess && pxbuffer != nil, "newPixelBuffer failed")
        
        CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pxdata = CVPixelBufferGetBaseAddress(pxbuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pxdata, width: frameWidth, height: frameHeight, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pxbuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        assert(context != nil, "context is nil")
        
        context!.concatenate(CGAffineTransform.identity)
        context!.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pxbuffer
    }

}
