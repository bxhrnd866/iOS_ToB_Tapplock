//
//  FingerPrintListCell.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/20.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import Kingfisher
class FingerPrintListCell: UITableViewCell {

    @IBOutlet weak var lockImg: UIImageView!
    
    @IBOutlet weak var decriptionLab: UILabel!
    
    @IBOutlet weak var emailLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    var model: LockHistoryModel? {
        didSet {
            
            self.emailLab.text = model?.mail
            self.timeLab.text = model?.operateTime?.operateTime
            
            
            let str = R.string.localizable.lockLog((model?.firstName)!, (model?.lockName)!)
            
            let attrStr = NSMutableAttributedString.init(string: str)
            
            attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 14) ?? UIFont.boldSystemFont(ofSize: 14),
                                   NSAttributedStringKey.foregroundColor: UIColor("#30bdde")],
                                  range: NSRange.init(location: 0, length: str.length))
            
            if model?.firstName != nil && (model?.firstName!.length)! > 0 {
                attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 14),
                                       NSAttributedStringKey.foregroundColor: UIColor("#30bdde")],
                                      range: NSRange((str.range(of: (model?.firstName)!))!, in: str))
            }
            
            attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 14),
                                   NSAttributedStringKey.foregroundColor: UIColor.themeColor],
                                  range: NSRange((str.range(of: (model?.lockName)!))!, in: str))
            
            decriptionLab.attributedText = attrStr
            
            guard let ul = model?.imageUrl else {
                self.lockImg.image = R.image.userPlace()
                return
            }
            if let url = URL(string: ul) {
                self.lockImg.kf.setImage(with: ImageResource.init(downloadURL: url), options: [.processor(kfProcessor)])
            } else {
                self.lockImg.image = R.image.userPlace()
            }
        }
    }
}
