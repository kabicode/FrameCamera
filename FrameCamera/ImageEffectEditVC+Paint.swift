//
//  ImageEffectEditVC+Paint.swift
//  PingGuo
//
//  Created by ShenMu on 2017/7/5.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

import Foundation

extension ImageEffectEditVC {
    func configurePaintBoardView() {
        paintColorCollectionView.dataSource = self
        paintColorCollectionView.delegate = self
        
    }
}
