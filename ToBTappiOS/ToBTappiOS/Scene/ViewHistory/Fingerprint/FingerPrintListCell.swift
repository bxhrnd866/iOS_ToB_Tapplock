//
//  FingerPrintListCell.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/20.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit

class FingerPrintListCell: UITableViewCell {

    @IBOutlet weak var lockImg: UIImageView!
    
    @IBOutlet weak var decriptionLab: UILabel!
    
    @IBOutlet weak var emailLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
//    func setModel(_ model: FingerprintHistoryModel) {
//        if (model.fingerOwnerName != nil && model.lockName != nil){
//            let str = R.string.localizable.lockLog(model.fingerOwnerName!, model.lockName!)
//            //        let str = "\(model.fingerOwnerName!) opened the lock \(model.lockName!)"
//
//
//            let attrStr = NSMutableAttributedString.init(string: str)
//            attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 14) ?? UIFont.boldSystemFont(ofSize: 14),
//                                   NSAttributedStringKey.foregroundColor: UIColor("#30bdde")],
//                                  range: NSRange.init(location: 0, length: str.length))
//            if model.fingerOwnerName != nil && model.fingerOwnerName.length > 0 {
//                attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 14)],
//                                      range: NSRange((str.range(of: model.fingerOwnerName!))!, in: str))
//            }
//            if model.lockName != nil && model.lockName.length > 0 {
//                attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 14),
//                                       NSAttributedStringKey.foregroundColor: UIColor.themeColor],
//                                      range: NSRange((str.range(of: model.lockName!))!, in: str))
//            }
//
//
//
//            label?.attributedText = attrStr
//        }
//
//        if model.closeTime != nil {
//
//            self.closeTime.text =  Date.tampCoverToStringTime(tamp: model.closeTime!)
//
//        }
//
//        if model.openTime != nil {
//             self.openTime.text = Date.tampCoverToStringTime(tamp: model.openTime!)
//             self.openImg.isHidden = false
//        }
//
//
//    }

}
