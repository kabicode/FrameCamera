//
//  AudioLibrarySectionHeaderView.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/13.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import UIKit

class AudioLibrarySectionHeaderView: UITableViewHeaderFooterView {

    var bottomView: UIView?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        bottomView = UIView()
        bottomView?.backgroundColor = UIColor(hex: 0x1C232D)
        contentView.addSubview(bottomView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomView?.frame = CGRect.init(x: 0, y: frame.size.height - 0.5, width: frame.size.width, height: 0.5)
        textLabel?.font = UIFont.systemFont(ofSize: 11)
        textLabel?.textColor = UIColor(hex: 0xb5b5b5)
        contentView.backgroundColor = UIColor(hex: 0x232D37)
        clipsToBounds = true
    }
}
