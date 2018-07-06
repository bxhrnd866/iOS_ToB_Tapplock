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

    func setModel(_ model: BluetoothHistoryModel) {

        let str = R.string.localizable.lockLog(model.firstName!, model.lockName!)
     
        
        let attrStr = NSMutableAttributedString.init(string: str)
        
        attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 14) ?? UIFont.boldSystemFont(ofSize: 14),
                               NSAttributedStringKey.foregroundColor: UIColor("#30bdde")],
                range: NSRange.init(location: 0, length: str.length))

        if model.firstName != nil && model.firstName!.length > 0 {
            attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 14),
                                   NSAttributedStringKey.foregroundColor: UIColor("#30bdde")],
                    range: NSRange((str.range(of: model.firstName!))!, in: str))
        }


        attrStr.addAttributes([NSAttributedStringKey.font: UIFont(name: font_name, size: 16) ?? UIFont.boldSystemFont(ofSize: 14),
                               NSAttributedStringKey.foregroundColor: UIColor.themeColor],
                range: NSRange((str.range(of: model.lockName!))!, in: str))

        descriptionLabel.attributedText = attrStr
        timeLabel.text = model.timeText
        locationLabel.text = model.location

        let timeStemp = Double(model.timeText!)
        if timeStemp != nil && timeStemp != 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timeText = dateFormatter.string(from: Date.init(timeIntervalSince1970: (Double(model.timeText ?? "0") ?? 0)))
            timeLabel.text = timeText
        }
        
        guard let ul = model.imageUrl else {
            self.portraitImageView.image = R.image.placeholder_lock()
            return
        }
        if let url = URL(string: ul) {
            self.portraitImageView.kf.setImage(with: ImageResource.init(downloadURL: url), options: [.processor(kfProcessor)])
        } else {
            self.portraitImageView.image = R.image.placeholder_lock()
        }
    }
}
