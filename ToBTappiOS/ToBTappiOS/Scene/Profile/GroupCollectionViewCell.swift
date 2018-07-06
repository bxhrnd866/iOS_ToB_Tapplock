//
//  GroupCollectionViewCell.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/5.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tagLab.layer.cornerRadius = 6
        self.tagLab.layer.masksToBounds = true
    }
}
