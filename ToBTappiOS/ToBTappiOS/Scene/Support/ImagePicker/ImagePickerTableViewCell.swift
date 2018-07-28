//
//  ImagePickerTableViewCell.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/10.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit

class ImagePickerTableViewCell: UITableViewCell {
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
