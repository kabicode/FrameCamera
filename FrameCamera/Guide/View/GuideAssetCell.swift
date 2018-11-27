//
//  GuideAssetCell.swift
//  PingGuo
//
//  Created by ShenMu on 2018/11/21.
//  Copyright © 2018 ShenMu. All rights reserved.
//

import UIKit

class GuideAssetCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var downloadedTag: UILabel!
    
    @IBOutlet weak var assetNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        assetNameLabel.layer.cornerRadius = 4.0
        assetNameLabel.layer.masksToBounds = true
        downloadedTag.layer.cornerRadius = 4.0
        downloadedTag.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let nameWidth = (assetNameLabel.text ?? "").boundingRect(with: CGSize(width: self.frame.width - 20.0,
                                                                                         height: CGFloat.infinity), options: .usesLineFragmentOrigin,
                                                                                                                    context: nil).size.width + 10.0
        assetNameLabel.frame = CGRect.init(x: self.frame.width - 8.0 - nameWidth, y: 8.0, width: nameWidth, height: assetNameLabel.frame.height)
        
        let tagWidth = (downloadedTag.text ?? "").boundingRect(with: CGSize(width: self.frame.width - 20.0,
                                                                              height: CGFloat.infinity), options: .usesLineFragmentOrigin,
                                                                                                         context: nil).size.width + 10.0
        downloadedTag.frame = CGRect.init(x: 8.0,
                                          y: self.frame.height - 8.0 - self.downloadedTag.frame.height,
                                          width: tagWidth,
                                          height: downloadedTag.frame.height)
    }
    
    func configureCell(with model:GuideAssetModel) {
        postImageView.kf.setImage(with: URL(string: model.postImage))
        downloadedTag.isHidden = !model.isDownloaded
        downloadedTag.textAlignment = .center
        downloadedTag.text = "已下载"
        if model.title.count > 0 {
            assetNameLabel.textAlignment = .center
            assetNameLabel.text = model.title
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}
