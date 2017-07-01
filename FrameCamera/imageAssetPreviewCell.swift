//
//  imageAssetPreviewCell.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/1.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit
import Kingfisher

class imageAssetPreviewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with image: PGImage) {
        imageView.kf.setImage(with: URL.init(fileURLWithPath: image.sandboxPath))
    }

    func selectedCell(_ selected: Bool) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = selected ? UIColor(hex: 0xF6A900).cgColor: UIColor.clear.cgColor
    }
}
