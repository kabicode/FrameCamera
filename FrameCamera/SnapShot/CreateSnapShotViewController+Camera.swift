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
        mCaptureSession.sessionPreset = AVCaptureSessionPreset1280x720;
        
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
        mCaptureDeviceOutput.alwaysDiscardsLateVideoFrames = false
        
        mGLView.isFullYUVRange = true
        mCaptureDeviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        mCaptureDeviceOutput.setSampleBufferDelegate(self, queue: mProcessQueue)
        if mCaptureSession.canAddOutput(mCaptureDeviceOutput) {
            mCaptureSession.addOutput(mCaptureDeviceOutput)
        }
        
        let connection = mCaptureDeviceOutput.connection(withMediaType: AVMediaTypeVideo)
        connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        
        mCaptureSession.startRunning()
    }
    
}


extension CreateSnapShotViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        mGLView.display(pixelBuffer)
    }
    
}

