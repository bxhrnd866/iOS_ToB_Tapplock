//
//  BluetoothHistoryCell.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/20.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import Kingfisher

class BluetoothHistoryCell: UITableViewCell {

    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var emaliLab: UILabel!
    
    var model: LockHistoryModel? {
        didSet {
            self.emaliLab.text = model?.mail
            self.locationLabel.text = model?.location
            
    
            self.timeLabel.text = model?.timeDate
            
            
            
            if let first = model?.firstName, let lock = model?.lockName {
                let str = R.string.localizable.lockLog(first, lock)
                
                let attrStr = NSMutableAttributedString.init(string: str)
                
                attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 16),
                                       NSAttributedStringKey.foregroundColor: UIColor("#30bdde")],
                                      range: NSRange((str.range(of: first))!, in: str))
                
                attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 16),
                                       NSAttributedStringKey.foregroundColor: UIColor.themeColor],
                                      range: NSRange((str.range(of: lock))!, in: str))
                
                descriptionLabel.attributedText = attrStr
            }  else {
                descriptionLabel.text = ""
            }
            
            
            guard let ul = model?.photoUrl else {
                self.portraitImageView.image = R.image.userPlace()
                return
            }
            if let url = URL(string: ul) {
                
                self.portraitImageView.kf.setImage(with: ImageResource.init(downloadURL: url), placeholder: R.image.userPlace(), options: [.processor(kfProcessor)])
            } else {
                self.portraitImageView.image = R.image.userPlace()
            }
        }
    }
    

}
