//
//  UserGroupCell.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class UserGroupCell: UITableViewCell {

    
    @IBOutlet weak var groupLab: UILabel!
    
    var model: GroupsModel? {
        didSet {
            groupLab.text = model?.groupName
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
