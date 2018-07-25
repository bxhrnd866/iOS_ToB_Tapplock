//
//  AllLocksCell.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class AllLocksCell: UITableViewCell {
    
    @IBOutlet weak var lockImg: UIImageView!
    
    @IBOutlet weak var lockName: UILabel!
    
    var model: TapplockModel? {
        didSet {
            lockName.text = model?.lockName
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
