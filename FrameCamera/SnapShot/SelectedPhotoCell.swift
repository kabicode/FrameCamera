//
//  SelectedPhotoCell.swift
//  PingGuo
//
//  Created by ShenMu on 2017/6/19.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class SelectedPhotoCell: UICollectionViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func selectedImage(_ selected: Bool) {
        self.isSelected = selected
        selectedImageView.isHidden = !selected
    }

}
