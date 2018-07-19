//
//  TappLockListCell.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/18.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class TappLockListCell: UITableViewCell {

    @IBOutlet weak var headerImg: UIImageView!
    
    @IBOutlet weak var lockName: UILabel!
    
    @IBOutlet weak var statusLab: UILabel!
    
    @IBOutlet weak var dot: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    var model: TapplockModel? {
        didSet {
            
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.genlaGradientlayer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
