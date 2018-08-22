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
            
            self.emailLab.text = self.model?.mail
        
            self.timeLab.text = self.model?.timeDate
            
            
    
            if model?.firstName == nil || model?.lockName == nil {
                
                decriptionLab.text = ""
            } else {
                let str = R.string.localizable.lockLog((model?.firstName)!, (model?.lockName)!)
                
                let length01 = (model?.firstName?.length)!
                
                let range01 = NSRange(location: 0, length: length01)
                
                let length02 = (model?.lockName?.length)!
                
                let ranglo02 = NSRange(location: str.length - length02, length: length02)
                
                let attr = NSMutableAttributedString(string: str)
                
                attr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.themeColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], range: ranglo02)
                attr.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], range: range01)
                
                self.decriptionLab.attributedText = attr
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
}
