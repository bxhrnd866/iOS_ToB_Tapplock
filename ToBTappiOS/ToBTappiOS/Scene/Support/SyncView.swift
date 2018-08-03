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
class SyncView: UIView {
    
    static let instance = SyncView(frame: CGRect(x: mScreenW - 100, y: mScreenH - 150, width: 50, height: 50))
    
    var rx_hidden: Variable<Bool> = Variable(false)

    var imgView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let window = UIApplication.shared.delegate?.window!
        window?.addSubview(self)
        self.layer.zPosition = .greatestFiniteMagnitude
        
        imgView.image = R.image.lock_sysn()
        imgView.isUserInteractionEnabled = true
        
        self.addSubview(imgView)
        
        rx_hidden.asDriver().drive(self.rx.isHidden).disposed(by: rx.disposeBag)
        
        rx_hidden.asDriver().drive(onNext: { [weak self] bl in
            
            self?.isHidden = bl
            if bl {
                self?.endAnimation()
                
            } else {
                self?.startAnimation()
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
    
}
