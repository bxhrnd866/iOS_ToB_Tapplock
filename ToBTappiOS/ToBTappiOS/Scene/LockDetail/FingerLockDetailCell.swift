//
//  FingerLockDetailCell.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/8/6.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import Kingfisher
class FingerLockDetailCell: UITableViewCell {

    @IBOutlet weak var lockImg: UIImageView!
    
    @IBOutlet weak var descriptionLab: UILabel!
    
    @IBOutlet weak var mailLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    var model: LockHistoryModel? {
        didSet {
            
            self.mailLab.text = model?.mail
            
            self.timeLab.text = model?.timeDate
            
            plog("\(model?.firstName)----\(model?.lockName)")
            
            if let first = model?.firstName, let lock = model?.lockName {
                let str = R.string.localizable.lockLog(first, lock)
                
                let attrStr = NSMutableAttributedString.init(string: str)
                
                attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 16),
                                       NSAttributedStringKey.foregroundColor: UIColor("#30bdde")],
                                      range: NSRange((str.range(of: first))!, in: str))
                
                attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 16),
                                       NSAttributedStringKey.foregroundColor: UIColor.themeColor],
                                      range: NSRange((str.range(of: lock))!, in: str))
                
                descriptionLab.attributedText = attrStr
            } else {
                descriptionLab.text = ""
            }
            
            
            guard let ul = model?.photoUrl else {
                self.lockImg.image = R.image.userPlace()
                return
            }
            
            if let url = URL(string: ul) {
                self.lockImg.kf.setImage(with: ImageResource.init(downloadURL: url), placeholder: R.image.userPlace(), options: [.processor(kfProcessor)])
            } else {
                self.lockImg.image = R.image.userPlace()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
