//
//  MenuTableViewCell.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/3.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var lable: UILabel!
    
    var model: MenuModel? {
        didSet {
            lable.text = self.model?.text
            
            if self.model?.select == true {
                self.contentView.backgroundColor = thembColor
                self.lable.textColor = UIColor.white
            } else {
                self.contentView.backgroundColor = UIColor.white
                self.lable.textColor = UIColor.black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
