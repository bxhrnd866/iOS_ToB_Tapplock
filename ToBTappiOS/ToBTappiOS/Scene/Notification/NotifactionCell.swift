//
//  NotifactionCell.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/8/2.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class NotifactionCell: UITableViewCell {

    var model: String?
    
    @IBOutlet weak var labtext: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
