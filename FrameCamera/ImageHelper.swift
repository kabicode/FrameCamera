////
////  ImageHelper.swift
////  Weike
////
////  Created by yake on 16/8/16.
////  Copyright © 2016年 Kuaizai. All rights reserved.
////
//
//import UIKit
//import MobileCoreServices
//import PSTAlertController
//
//class ImageHelper {
//    
//    /// scale image data
//    ///
//    /// - Parameters:
//    ///   - image: image to scale
//    ///   - size: maximum size, unit is KB, default is 5MB
//    /// - Returns: scaled image data
//    static func scaleImage(_ image: UIImage, maximumSize size: Int = 5 * 1024) -> Data? {
//        // size unit: KB
//        var data = UIImageJPEGRepresentation(image, 1.0)
//        
//        var scale: CGFloat = 0.9
//        let maximumSize = size * 1024
//        while data != nil && data!.count > maximumSize && scale >= 0 {
//            data = UIImageJPEGRepresentation(image, scale)
//            scale -= 0.1
//        }
//        return data
//    }
//    
//    static func getHDImageURLString(_ urlString: String) -> String {
//        var str = urlString
//        if let range = str.range(of: "-", options: .backwards) {
//            str = str.substring(to: range.lowerBound)
//        }
//        return str
//    }
//    
//    static func scaleImagesAspect(with images: [UIImage], to targetSize: CGSize) -> UIImage? {
//        UIGraphicsBeginImageContext(targetSize)
//
//        for image in images {
//            let sourceSize = image.size
//            let sourceRatio = sourceSize.width / sourceSize.height
//            let targetRatio = targetSize.width / targetSize.height
//            
//            let width: CGFloat
//            let height: CGFloat
//            if sourceRatio > targetRatio {
//                width = targetSize.width
//                height = width / sourceRatio
//            } else {
//                height = targetSize.height
//                width = height * sourceRatio
//            }
//            
//            let positionRect = CGRect(
//                x: (targetSize.width - width) / 2,
//                y: (targetSize.height - height) / 2,
//                width: width,
//                height: height)
//            image.draw(in: positionRect)
//        }
//        
//        let waterMaskImage = UIImage(named: "VideoWaterMask")!
//        let waterMaskImageWidth: CGFloat = 100
//        let waterMaskImageHeight: CGFloat = 36
//        let waterMaskPositionRect = CGRect(
//            x: targetSize.width - waterMaskImageWidth - 10,
//            y: 0,
//            width: waterMaskImageWidth,
//            height: waterMaskImageHeight)
//        waterMaskImage.draw(in: waterMaskPositionRect)
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
//    
//    static func checkImagePickerAvailablityForSourceType(_ sourceType: UIImagePickerControllerSourceType, mediaType: String) -> Bool {
//        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
//            return false
//        }
//        if let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType) {
//            for type in availableMediaTypes {
//                if type == mediaType {
//                    return true
//                }
//            }
//        }
//        return false
//    }
//    
//    static func presentImagePickerActionSheet(
//        _ title: String,
//        delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
//        sender: UIView,
//        viewController: UIViewController) {
//        
//        let alert = PSTAlertController.actionSheet(withTitle: title)
//        let mediaType = kUTTypeImage as String
//        
//        if ImageHelper.checkImagePickerAvailablityForSourceType(.camera, mediaType: mediaType) {
//            let takePhoto = PSTAlertAction(
//                title: NSLocalizedString("imagePicker.takePhoto", comment: "Take Photo"),
//                style: .default) { action in
//                    let imagePicker = UIImagePickerController()
//                    imagePicker.sourceType = .camera
//                    imagePicker.mediaTypes = [mediaType]
//                    imagePicker.delegate = delegate
//                    (delegate as? UIViewController)?.present(imagePicker, animated: true, completion: nil)
//            }
//            alert.addAction(takePhoto)
//        }
//        
//        if ImageHelper.checkImagePickerAvailablityForSourceType(.photoLibrary, mediaType: mediaType) {
//            let chooseFromPhotos = PSTAlertAction(
//                title: NSLocalizedString("imagePicker.seletePhoto.fromAlbum", comment: "Select From Photo Album"),
//                style: .default) { action in
//                    let imagePicker = UIImagePickerController()
//                    imagePicker.sourceType = .photoLibrary
//                    imagePicker.mediaTypes = [mediaType]
//                    imagePicker.delegate = delegate
//                    (delegate as? UIViewController)?.present(imagePicker, animated: true, completion: nil)
//            }
//            alert.addAction(chooseFromPhotos)
//        }
//        
//        let cancel = PSTAlertAction(
//            title: NSLocalizedString("common.cancel", comment: "Alert Cancel"),
//            style: .cancel, handler: nil)
//        alert.addAction(cancel)
//        
//        alert.showWithSender(sender, arrowDirection: .any, controller: viewController, animated: true, completion: nil)
//    }
//    
//    static func presentVideoPickerActionSheet(
//        with title: String?,
//        delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
//        sender: UIView,
//        viewController: UIViewController,
//        pasteVideoUrl: Bool = false,
//        pasteVideoUrlHandle: ((_ uslString: String)->())? = nil) {
//        
//        let alert = PSTAlertController.actionSheet(withTitle: title)
//        let mediaType = kUTTypeMovie as String
//        
//        if pasteVideoUrl {
//            let pasteVideo = PSTAlertAction(title: NSLocalizedString("imagePicker.pasteVideoUrl", comment: "Video Link"), handler: { [weak viewController] (action) in
//                
//                let alertController = UIAlertController(
//                    title: LectureRoomLocalizedString("videoMaterial.pasteVideoURL.title", comment: "Paste video url material title"),
//                    message: nil,
//                    preferredStyle: .alert)
//                alertController.addTextField(configurationHandler: { (textField) in
//                    textField.placeholder = NSLocalizedString("imagePicker.pasteVideoUrl", comment: "Video Link")
//                })
//
//                let send = UIAlertAction(
//                    title: LectureRoomLocalizedString("videoMaterial.pasteVideoURL.sendAction", comment: "Send video material action"),
//                    style: .default) { [weak alertController] (action) in
//                        guard let urlString = alertController?.textFields![0].text, !urlString.isEmpty else {
//                            let message = LectureRoomLocalizedString("videoMaterial.pasteVideoURL.emptyURLError", comment: "URL can't be empty")
//                            showMessageNotifiaction(message, on: viewController)
//                            return
//                        }
//                        pasteVideoUrlHandle?(urlString)
//                }
//                alertController.addAction(send)
//
//                let cancel = UIAlertAction(
//                    title: NSLocalizedString("common.cancel", comment: "Cancel"),
//                    style: .cancel, handler: nil)
//                alertController.addAction(cancel)
//
//                viewController?.present(alertController, animated: true, completion: nil)
//            })
//            alert.addAction(pasteVideo)
//        }
//        
//        if ImageHelper.checkImagePickerAvailablityForSourceType(.camera, mediaType: mediaType) {
//            let takePhoto = PSTAlertAction(
//                title: NSLocalizedString("imagePicker.recordVideo", comment: "Record Photo"),
//                style: .default) { [weak delegate] action in
//                    let imagePicker = UIImagePickerController()
//                    imagePicker.sourceType = .camera
//                    imagePicker.mediaTypes = [mediaType]
//                    imagePicker.delegate = delegate
//                    (delegate as? UIViewController)?.present(imagePicker, animated: true, completion: nil)
//            }
//            alert.addAction(takePhoto)
//        }
//        
//        if ImageHelper.checkImagePickerAvailablityForSourceType(.photoLibrary, mediaType: mediaType) {
//            let chooseFromPhotos = PSTAlertAction(
//                title: NSLocalizedString("imagePicker.seletePhoto.fromAlbum", comment: "Select From Photo Album"),
//                style: .default) { [weak delegate] action in
//                    let imagePicker = UIImagePickerController()
//                    imagePicker.sourceType = .photoLibrary
//                    imagePicker.mediaTypes = [mediaType]
//                    imagePicker.delegate = delegate
//                    (delegate as? UIViewController)?.present(imagePicker, animated: true, completion: nil)
//            }
//            alert.addAction(chooseFromPhotos)
//        }
//        
//        let cancel = PSTAlertAction(
//            title: NSLocalizedString("common.cancel", comment: "Alert Cancel"),
//            style: .cancel, handler: nil)
//        alert.addAction(cancel)
//        
//        alert.showWithSender(sender, arrowDirection: .any, controller: viewController, animated: true, completion: nil)
//    }
//}
//
//extension UIImage {
//    func resizeImage(scale: CGFloat) -> UIImage? {
//        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
//        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//        
//        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
////        UIGraphicsBeginImageContext(newSize)
//        self.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
//}
