//
//  AudioFileCell.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/13.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class AudioFileCell: UITableViewCell {

    @IBOutlet weak var audioNameLabel: UILabel!
    @IBOutlet weak var checkBoxView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkBoxView.isHidden = true
    }

    func selectedAudio(_ selected: Bool) {
        if selected {
            audioNameLabel.textColor = UIColor.yellowTheme
            checkBoxView.isHidden = false
        } else {
            audioNameLabel.textColor = UIColor(hex: 0xB5B5B5)
            checkBoxView.isHidden = true
        }
    }
}
