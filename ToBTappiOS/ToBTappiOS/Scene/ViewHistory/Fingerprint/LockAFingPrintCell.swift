//
//  LockAFingPrintCell.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/5/30.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import UIKit

class LockAFingPrintCell: UITableViewCell {

    @IBOutlet weak var labTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(_ model: FingerprintHistoryModel) {
        if (model.fingerOwnerName != nil && model.lockName != nil){
            let str = R.string.localizable.lockLog(model.fingerOwnerName!, model.lockName!)
            //        let str = "\(model.fingerOwnerName!) opened the lock \(model.lockName!)"
            
            
            let attrStr = NSMutableAttributedString.init(string: str)
            attrStr.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14) ,
                                   NSAttributedStringKey.foregroundColor: UIColor("#30bdde")],
                                  range: NSRange.init(location: 0, length: str.length))
            if model.fingerOwnerName != nil && model.fingerOwnerName.length > 0 {
                attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 14)],
                                      range: NSRange((str.range(of: model.fingerOwnerName!))!, in: str))
            }
            if model.lockName != nil && model.lockName.length > 0 {
                attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 14),
                                       NSAttributedStringKey.foregroundColor: UIColor.themeColor],
                                      range: NSRange((str.range(of: model.lockName!))!, in: str))
            }
            
            labTitle?.attributedText = attrStr
        }
        
    }

}
