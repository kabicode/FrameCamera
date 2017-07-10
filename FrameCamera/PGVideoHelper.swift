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

class PGVideoHelper: NSObject {
    
    static var fps: Int32 = 30
    
    // 生成视频名
    static func generateVideoFileName(at filePath: String) -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileName: String = "\(timestamp)_video.mp4"
        let imgFilePath: String = filePath + "/" + fileName
        return imgFilePath
    }
    
    //MARK: Public methods
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
        
        let videoSettings:[String: Any] = [AVVideoCodecKey: AVVideoCodecH264,
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
                        if imageIndex > 0 {
                            let pgImage = pgImages[imageIndex - 1]
                            let presentTime = CMTimeMake(Int64(pgImage.duration * TimeInterval(fps)), fps)
                            lastTime = CMTimeAdd(lastTime, presentTime)
                        }
                        
                        bufferAdapter.append(sampleBuffer!, withPresentationTime: lastTime)
                        imageIndex = imageIndex + 1
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
