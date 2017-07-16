//
//  CropImagePickViewController.swift
//  PingGuo
//
//  Created by ShenMu on 2017/6/19.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices


class CropImagePickViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var selecteFromNetworkButton: UIButton!
    @IBOutlet weak var selecteFromLibraryButton: UIButton!
    @IBOutlet weak var bottomLineLeadingConstraint: NSLayoutConstraint!
    
    var imageList: [CropBgImage] = []
    var selectedImage: CropBgImage?
    
    var selectedImageBlock: ((_ selectedImage: CropBgImage?)->())?
    
    // MARK: - Rotate
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeOrientation(to: .landscapeRight)
    }
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "CropImagePickViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        collectionView.contentInset = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing          = 6;
        layout.minimumInteritemSpacing     = 8.0;
        layout.itemSize                    = CGSize.init(width: 156.0, height: 100)
        layout.scrollDirection             = .vertical;
        
        collectionView.register(UINib.init(nibName: "SelectedPhotoCell", bundle: nil), forCellWithReuseIdentifier: "SelectedPhotoCell")
        
        collectionView.collectionViewLayout = layout;
        collectionView.dataSource = self;
        collectionView.delegate   = self;
        
        loadData()
        tapSelectFromNetWork(selecteFromNetworkButton)
    }
    
    //  MARK: - Event Method
    @IBAction func tapBarBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapDoneButton(_ sender: Any) {
        selectedImageBlock?(selectedImage)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func tapSelectFromNetWork(_ sender: UIButton) {
        selecteFromNetworkButton.isSelected = true
        selecteFromLibraryButton.isSelected = false
        bottomLineLeadingConstraint.constant = 0
    }
    
    @IBAction func tapSelectFromLibrary(_ sender: UIButton) {
//        selecteFromNetworkButton.isSelected = false
//        selecteFromLibraryButton.isSelected = true
//        bottomLineLeadingConstraint.constant = selecteFromLibraryButton.frame.width
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Private Method
    func loadData() {
        let request = Router.Camera.getBackgroundPosterList
        NetworkHelper.sendNetworkRequest(request: request, showHUD: true, on: self, successHandler: { (json) in
            print("\(json)")
            let jsons = json["Data"].arrayValue
            
            self.imageList.removeAll()
            jsons.forEach({ (json) in
                self.imageList.append(CropBgImage(from: json))
            })
            self.collectionView.reloadData()
            
        }, failureHandler: {
        })
    }
}

extension CropImagePickViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = 4
        let width: CGFloat = ( UIScreen.main.bounds.width - CGFloat((count + 1) * 8) ) / CGFloat(count)
        let height: CGFloat = width * (UIScreen.main.bounds.height / UIScreen.main.bounds.width)
        return CGSize.init(width: width, height: height)
    }
}

extension CropImagePickViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPhotoCell", for: indexPath) as! SelectedPhotoCell
        let image = imageList[indexPath.row]
        if image.image != nil {
            cell.bgImageView.image = image.image
        } else {
            cell.bgImageView.kf.setImage(with: URL(string: image.url))
        }
        cell.selectedImage(selectedImage == image)
        return cell
    }
}

extension CropImagePickViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SelectedPhotoCell
        let image = imageList[indexPath.row]
        selectedImage = image
        if selectedImage?.image == nil {
            selectedImage?.image = cell.bgImageView.image
        }
        collectionView.reloadData()
    }
}

// MARK: - Image Picker Controller Delegate
extension CropImagePickViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let url = info[UIImagePickerControllerReferenceURL] as! URL
        
        let bgImage = CropBgImage()
        bgImage.url = url.absoluteString
        bgImage.image = image
        
        if !imageList.contains(bgImage) {
            imageList.append(bgImage)
        }
        selectedImage = bgImage
        collectionView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

