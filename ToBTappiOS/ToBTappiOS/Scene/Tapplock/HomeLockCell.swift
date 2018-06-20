//
//  HomeLockCell.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class HomeLockCell: UITableViewCell {

    @IBOutlet weak var lockImg: UIImageView!
    
    @IBOutlet weak var dotView: UIView!
    
    @IBOutlet weak var lockname: UILabel!
    
    @IBOutlet weak var lockState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
