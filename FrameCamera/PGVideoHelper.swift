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
                              size: CGSize) {
//        guard pgImages.count > 0 else {
//            return
//        }
        
        var videoWriter: AVAssetWriter
        do {
            try videoWriter = AVAssetWriter(url: URL(fileURLWithPath: path), fileType: AVFileTypeMPEG4)
        } catch {
            print("视频初始化失败")
            return
        }
        
        let videoSetting: [String: Any] = [AVVideoCodecKey: AVVideoCodecH264,
                                           AVVideoWidthKey: NSNumber(value: Float(size.width)),
                                           AVVideoHeightKey: NSNumber(value: Float(size.height))]
        
        let writerInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoSetting)
        let adaptor = AVAssetWriterInputPixelBufferAdaptor.init(assetWriterInput: writerInput, sourcePixelBufferAttributes: nil)
        videoWriter.add(writerInput)
        
        // Start a session:
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: kCMTimeZero)
        
        var buffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, adaptor.pixelBufferPool!, &buffer)
        
        var presentTime = CMTimeMake(0, fps);
        var frameIndex: Int64 = 0
        
        var imageIndex = 0
        var currentImageFrameMaxCount: Int64 = 0
        if let pgImage = pgImages.first {
            currentImageFrameMaxCount = Int64(pgImage.duration * TimeInterval(fps))
            if let image = pgImage.image, let cgImage = image.cgImage {
                buffer = pixelBuffer(from: cgImage, size: image.size)
            }
        }
        
        while true {
            if writerInput.isReadyForMoreMediaData {
                presentTime = CMTimeMake(frameIndex, fps)
                
                if imageIndex >= pgImages.count {
                    buffer = nil;
                } else if (frameIndex > currentImageFrameMaxCount) {
                    let nextIndex = imageIndex + 1
                    if nextIndex >= pgImages.count {
                        buffer = nil
                    } else {
                        let pgImage = pgImages[nextIndex]
                        let nextFrameCount = Int64(pgImage.duration * TimeInterval(fps))

                        if let image = pgImage.image, let cgImage = image.cgImage {
                            buffer = pixelBuffer(from: cgImage, size: image.size)
                        }
                        
                        currentImageFrameMaxCount += nextFrameCount
                        imageIndex = nextIndex
                    }
                }
                
                if let buffer = buffer {
                    let appendSuccess: Bool = appendToAdapter(adaptor,
                                                        pixelBuffer: buffer,
                                                        atTime: presentTime,
                                                        with: writerInput)
                    assert(appendSuccess, "Failed to append")
                    
                    frameIndex += 1
                    
                } else {
                    //Finish the session:
                    writerInput.markAsFinished()
                    
                    videoWriter.finishWriting(completionHandler: { 
                        print("Successfully closed video writer")
                        if videoWriter.status == .completed {
                            // TODO
                        }
                    })
                    
                    print("Done")
                    break
                }
                
            }
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
        let context = CGContext.init(data: pxdata!, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(size.width), space: rgbColorSpace, bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        assert(context != nil)
        
        context!.draw(cgImage, in: CGRect(x: 0 + (Int(size.width) - cgImage.width)/2,
                                          y: (Int(size.height) - cgImage.height)/2,
                                          width: cgImage.width,
                                          height: cgImage.height))
        
        CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pxbuffer!
    }
    
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
