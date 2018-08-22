//
//  SyncView.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/31.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CFAlertViewController
class SyncView: UIView {
    
    static let instance = SyncView(frame: CGRect(x: mScreenW - 100, y: mScreenH - 150, width: 50, height: 50))
    
    var rx_numers: Variable<Int> = Variable(0)
    

    var imgView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let window = UIApplication.shared.delegate?.window!
        window?.addSubview(self)
        self.layer.zPosition = .greatestFiniteMagnitude
        
        imgView.image = R.image.lock_sysn()
        imgView.isUserInteractionEnabled = true
        
        self.addSubview(imgView)
        
        self.isHidden = true
        
        rx_numers.asDriver().drive(onNext: { [weak self] number in
            plog(number)
            if number > 0 {
                if self?.isHidden == true {
                    self?.isHidden = false
                    self?.showTotals(meg: R.string.localizable.dataNeedsToSync())
                    self?.startAnimation()
                }
            } else {
                if self?.isHidden == false {
                    self?.isHidden = true
                    self?.endAnimation()
                    self?.showTotals(meg: R.string.localizable.dataSyncCompeted())
                    
                }
            }

        }).disposed(by: rx.disposeBag)
        
        
    }
    
    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.beginTime = CACurrentMediaTime()
        animation.duration = 2.5
        animation.repeatCount = MAXFLOAT
        animation.fromValue = 0.0
        animation.toValue = 2 * Double.pi
        self.layer.add(animation, forKey: "haahhahaha")
        
    }
    
    private func endAnimation() {
        self.layer.removeAllAnimations()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func showTotals(meg: String) {
        
        let window = UIApplication.shared.delegate?.window!
        let x =  window?.rootViewController?.presentedViewController
        
        let alertController = CFAlertViewController(title: meg,
                                                    message: nil,
                                                    textAlignment: .left,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        alertController.shouldDismissOnBackgroundTap = false
        alertController.backgroundStyle = .blur
        alertController.backgroundColor = UIColor.clear
        
        let ok = CFAlertAction(title: R.string.localizable.oK(), style: .Default, alignment: .justified, backgroundColor: UIColor.themeColor, textColor: nil, handler: nil)
        
        alertController.addAction(ok)
        x?.present(alertController, animated: true, completion: nil)
    }
    
}
