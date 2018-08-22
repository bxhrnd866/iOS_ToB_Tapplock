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

    @IBOutlet weak var openLab: UILabel!
    @IBOutlet weak var emaliLab: UILabel!
    
    var model: LockHistoryModel? {
        didSet {
            self.emaliLab.text = model?.mail
            self.locationLabel.text = model?.location
            
    
            self.timeLabel.text = model?.timeDate
            
            
            if model?.firstName == nil || model?.lockName == nil {
                
                self.openLab.text = nil
            } else {
                let str = R.string.localizable.lockLog((model?.firstName)!, (model?.lockName)!)
                
                let length01 = (model?.firstName?.length)!
                
                let range01 = NSRange(location: 0, length: length01)
                
                let length02 = (model?.lockName?.length)!
                
                let ranglo02 = NSRange(location: str.length - length02, length: length02)
                
                let attr = NSMutableAttributedString(string: str)
                
                attr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.themeColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], range: ranglo02)
                attr.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], range: range01)
                
                self.openLab.attributedText = attr
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
