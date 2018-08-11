//
//  TappLockListCell.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/18.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class TappLockListCell: UITableViewCell {

    @IBOutlet weak var headerImg: UIImageView!
    
    @IBOutlet weak var lockName: UILabel!
    
    @IBOutlet weak var statusLab: UILabel!
    
    @IBOutlet weak var dot: UIView!
    
    @IBOutlet weak var bgView: UIView!
    
    var model: TapplockModel? {
        didSet {
            
            self.model?.rx_status.asDriver().drive(onNext: { [weak self] state in
                let bglayer = self?.bgView.layer.sublayers?.first!
                self?.statusLab.text = state?.textValue
                if state == .connected {
    
                    bglayer?.isHidden = false
                    self?.lockName.textColor = UIColor.white
                    self?.statusLab.textColor = UIColor.white
                    self?.dot.backgroundColor = UIColor("#3effbf")
                    self?.headerImg.image = R.image.home_lock2_s()

                } else {
                    
                    bglayer?.isHidden = true
                    self?.lockName.textColor = UIColor("#43485F")
                    self?.statusLab.textColor = UIColor("#43485F")
                    self?.dot.backgroundColor = UIColor("#d1d0d6")
                    self?.headerImg.image = R.image.home_lock2_n()
                }

            }).disposed(by: rx.disposeBag)
            
            self.lockName.text = model?.lockName
            
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
