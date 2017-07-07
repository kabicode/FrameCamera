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

class PGVideoHelper: NSObject {
    
    static var fps: Int32 = 30
    
    // 生成视频名
    static func generateVideoFileName(at filePath: String) -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName: String = "\(timestamp)_video.mp4"
        let imgFilePath: String = filePath + "/" + fileName
        return imgFilePath
    }
    
    static func converToVideo(from pgImages: [PGImage],
                              to path:String,
                              size: CGSize,
                              completionBlock:@escaping (() -> Void)) {
        
        var videoWriter: AVAssetWriter
        do {
            try videoWriter = AVAssetWriter(url: URL(fileURLWithPath: path), fileType: AVFileTypeQuickTimeMovie)
        } catch {
            print("视频初始化失败")
            return
        }
        
        let videoSetting: [String: Any] = [AVVideoCodecKey: AVVideoCodecH264,
                                           AVVideoWidthKey: NSNumber(value: Float(size.width)),
                                           AVVideoHeightKey: NSNumber(value: Float(size.height))]
        
        
        let writerInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoSetting)
        assert(videoWriter.canAdd(writerInput), "add failed")
        videoWriter.add(writerInput)
        
        let bufferAttributes:[String: Any] = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB)]
        let adaptor = AVAssetWriterInputPixelBufferAdaptor.init(assetWriterInput: writerInput, sourcePixelBufferAttributes: bufferAttributes)
        
        // Start a session:
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: kCMTimeZero)
        
        
        
        let mediaInputQueue = DispatchQueue(label: "mediaInputQueue")
        var imageIndex = 0
        var lastTime: CMTime = CMTimeMake(Int64(0), fps)
        
        writerInput.requestMediaDataWhenReady(on: mediaInputQueue) {
            while true {
                if imageIndex >= pgImages.count {
                    break
                }
                
                if writerInput.isReadyForMoreMediaData {
                    
                    var sampleBuffer:CVPixelBuffer?
                    autoreleasepool{
                        if let img = pgImages[imageIndex].image {
                            sampleBuffer = pixelBuffer(from: img.cgImage!, size: img.size)
                        } else {
                            imageIndex += 1
                            print("Warning: counld not extract one of the frames")
                            //                            continue
                        }
                    }
                    
                    if (sampleBuffer != nil){
                        adaptor.append(sampleBuffer!, withPresentationTime: lastTime)
                        
                        if imageIndex > 0 {
                            let pgImage = pgImages[imageIndex - 1]
                            let presentTime = CMTimeMake(Int64(pgImage.duration * TimeInterval(fps)), fps)
                            lastTime = CMTimeAdd(lastTime, presentTime)
                        }
                        
                        imageIndex = imageIndex + 1
                    }
                }
            }
            
            writerInput.markAsFinished()
            videoWriter.finishWriting(completionHandler: {
                print("Successfully closed video writer")
                DispatchQueue.main.sync {
                    completionBlock()
                }
            })
        }
    }
    
    
    
    static func pixelBuffer(from cgImage: CGImage, size: CGSize) -> CVPixelBuffer {
        let options: [AnyHashable: Any] = [(kCVPixelBufferCGImageCompatibilityKey as AnyHashable): NSNumber(value: true),
                                           (kCVPixelBufferCGBitmapContextCompatibilityKey as AnyHashable): NSNumber(value: true)]
        
        var pxbuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32ARGB, options as CFDictionary, &pxbuffer)
        assert((status == kCVReturnSuccess) && (pxbuffer != nil))
        
        CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pxdata = CVPixelBufferGetBaseAddress(pxbuffer!)
        assert(pxdata != nil)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
         let context = CGContext(data: pxdata, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pxbuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        assert(context != nil)
        
        context!.draw(cgImage, in: CGRect(x: 0,
                                          y: 0,
                                          width: cgImage.width,
                                          height: cgImage.height))
        
        CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pxbuffer!
    }
    
//    static func newPixelBufferFrom(cgImage:CGImage) -> CVPixelBuffer?{
//        let options:[String: Any] = [kCVPixelBufferCGImageCompatibilityKey as String: true, kCVPixelBufferCGBitmapContextCompatibilityKey as String: true]
//        var pxbuffer:CVPixelBuffer?
//        let frameWidth = self.videoSettings[AVVideoWidthKey] as! Int
//        let frameHeight = self.videoSettings[AVVideoHeightKey] as! Int
//        
//        let status = CVPixelBufferCreate(kCFAllocatorDefault, frameWidth, frameHeight, kCVPixelFormatType_32ARGB, options as CFDictionary?, &pxbuffer)
//        assert(status == kCVReturnSuccess && pxbuffer != nil, "newPixelBuffer failed")
//        
//        CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
//        let pxdata = CVPixelBufferGetBaseAddress(pxbuffer!)
//        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
//        let context = CGContext(data: pxdata, width: frameWidth, height: frameHeight, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pxbuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
//        assert(context != nil, "context is nil")
//        
//        context!.concatenate(CGAffineTransform.identity)
//        context!.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
//        CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
//        return pxbuffer
//    }

    
    static func appendToAdapter(_ adaptor: AVAssetWriterInputPixelBufferAdaptor,
                                pixelBuffer buffer: CVPixelBuffer,
                                atTime presentTime: CMTime,
                                with writerInput: AVAssetWriterInput) -> Bool {
        while !writerInput.isReadyForMoreMediaData {
            usleep(1)
        }
        
        return adaptor.append(buffer, withPresentationTime: presentTime)
    }
}
