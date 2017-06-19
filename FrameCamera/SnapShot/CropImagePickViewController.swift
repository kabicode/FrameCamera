//
//  CropImagePickViewController.swift
//  PingGuo
//
//  Created by ShenMu on 2017/6/19.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation
import UIKit


class CropImagePickViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var selecteFromNetworkButton: UIButton!
    @IBOutlet weak var selecteFromLibraryButton: UIButton!
    @IBOutlet weak var bottomLineLeadingConstraint: NSLayoutConstraint!
    
    
    // MARK: - Rotate
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeOrientation(to: .landscapeLeft)
    }
    
    // MARK: - Life Cycle
    init() {
        super.init(nibName: "CropImagePickViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing          = 10;
        layout.minimumInteritemSpacing     = 8.0;
        layout.itemSize                    = CGSize.init(width: 156.0, height: 100)
        layout.scrollDirection             = .vertical;
        
        collectionView.register(UINib.init(nibName: "SelectedPhotoCell", bundle: nil), forCellWithReuseIdentifier: "SelectedPhotoCell")
        
        collectionView.collectionViewLayout = layout;
        collectionView.dataSource = self;
        collectionView.delegate   = self;
        
        tapSelectFromNetWork(selecteFromNetworkButton)
    }
    
    //  MARK: - Event Method
    @IBAction func tapBarBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapDoneButton(_ sender: Any) {
        // TODO
    }

    @IBAction func tapSelectFromNetWork(_ sender: UIButton) {
        selecteFromNetworkButton.isSelected = true
        selecteFromLibraryButton.isSelected = false
        bottomLineLeadingConstraint.constant = 0
    }
    
    @IBAction func tapSelectFromLibrary(_ sender: UIButton) {
        selecteFromNetworkButton.isSelected = false
        selecteFromLibraryButton.isSelected = true
        bottomLineLeadingConstraint.constant = selecteFromLibraryButton.frame.width
    }
    
}

extension CropImagePickViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPhotoCell", for: indexPath) as! SelectedPhotoCell
        cell.selectedImage(true)
        return cell
    }
}

extension CropImagePickViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SelectedPhotoCell
        cell.selectedImage(!cell.isSelected)
    }
}

