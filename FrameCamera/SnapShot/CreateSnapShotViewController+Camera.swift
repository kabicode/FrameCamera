//
//  CreateSnapShotViewController+Camera.swift
//  PingGuo
//
//  Created by ShenMu on 2017/6/17.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import AVFoundation

extension CreateSnapShotViewController {
    
    func configureCamera() {
        mGLView = self.view as! LYOpenGLView
        mGLView.setupGL()
        
        mCaptureSession = AVCaptureSession()
        guard let mCaptureSession = self.mCaptureSession else {
            return
        }
        
        mCaptureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
        
        mProcessQueue = DispatchQueue.global()
        
        var inputCamera: AVCaptureDevice!
        let devices: [AVCaptureDevice] = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        for device in devices {
            if device.position == AVCaptureDevicePosition.back {
                inputCamera = device
            }
        }
        
        mCaptureDeviceInput = try? AVCaptureDeviceInput.init(device: inputCamera)
        if mCaptureSession.canAddInput(mCaptureDeviceInput) {
            mCaptureSession.addInput(mCaptureDeviceInput)
        }
        
        mCaptureDeviceOutput = AVCaptureVideoDataOutput()
        mCaptureDeviceOutput?.alwaysDiscardsLateVideoFrames = false
        
        mGLView.isFullYUVRange = true
        mCaptureDeviceOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        mCaptureDeviceOutput?.setSampleBufferDelegate(self, queue: mProcessQueue)
        if mCaptureSession.canAddOutput(mCaptureDeviceOutput) {
            mCaptureSession.addOutput(mCaptureDeviceOutput)
        }
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if mCaptureSession.canAddOutput(self.stillImageOutput) {
            mCaptureSession.addOutput(self.stillImageOutput)
        }
        
        let connection = mCaptureDeviceOutput?.connection(withMediaType: AVMediaTypeVideo)
        connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
        
        mCaptureSession.startRunning()
    }
    
    
    func focesCamera(tap: UITapGestureRecognizer) {
        if mCaptureDeviceInput?.device.position == AVCaptureDevicePosition.front {
            return
        }
        
        if tap.state == .recognized {
            let location: CGPoint = tap.location(in: view)
            focusAndExposeAtPoint(point: location)
        }
    }
    
    func focusAndExposeAtPoint(point: CGPoint) {
        self.mProcessQueue.async(execute: {
            
            let device: AVCaptureDevice = self.mCaptureDeviceInput!.device
            
            if ((try? device.lockForConfiguration()) != nil) {
                if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(AVCaptureFocusMode.autoFocus) {
                    device.focusPointOfInterest = point
                    device.focusMode = AVCaptureFocusMode.autoFocus
                }
                
                if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(AVCaptureExposureMode.autoExpose) {
                    device.exposurePointOfInterest = point
                    device.exposureMode = AVCaptureExposureMode.autoExpose
                }
                
                device.unlockForConfiguration()
            }
            else {
                print("Focus Error at point \(point)")
            }
        })
    }
    
    // 拍照
    func captureImage(completion:((_ image: UIImage?, _ error: NSError?) -> Void)?) {
        
        guard greenCropEnable else {
            if let connection = self.stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
                self.stillImageOutput?.captureStillImageAsynchronously(from: connection, completionHandler: { (buffer, error) in
                    
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                    if let originImage = UIImage.init(data: data!) {
                        let image = UIImage.init(cgImage: originImage.cgImage!, scale: UIScreen.main.scale, orientation: .up)
                        completion?(image, nil)
                    }
                })
            }
            return
        }
        
        if let view = self.view as? LYOpenGLView {
            self.mProcessQueue.async {
                let image = view.getGLScreenshot()
                DispatchQueue.main.async {
                    completion?(image, nil)
                }
            }
        }
    }
    
}


extension CreateSnapShotViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if self.greenCropEnable {
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            mGLView.display(pixelBuffer)
        }
    }
    
}

