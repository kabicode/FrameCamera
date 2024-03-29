//
//  VideoLibraryCell.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/1.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit
import Kingfisher

class VideoLibraryCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    func configureCell(with asset: PGAsset) {
        posterImageView.image = asset.posterImage
        createTimeLabel.text = asset.createTime
    }
    
}
