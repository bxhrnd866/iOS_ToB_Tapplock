//
//  NotificationModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/8/11.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation

class NoficationModel {
    var title: String?
    var body: String? {
        didSet {
            let text = self.body ?? "xxxx"
            let size = text.boundingRect(with: CGSize(width: mScreenW - 125, height: 1000), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)], context: nil).size
            self.cellHeight = size.height + 10
        }
    }
    
    var cellHeight: CGFloat?
}
