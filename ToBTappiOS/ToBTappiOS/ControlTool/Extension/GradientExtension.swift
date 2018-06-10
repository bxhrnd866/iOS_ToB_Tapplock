//
//  GradientExtension.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/10.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
extension CAGradientLayer {
    public static func gradientLayer(frame: CGRect, colorA: UIColor, colorB: UIColor, corner: CGFloat = 24) -> CAGradientLayer {
        
        let gradColor = [colorA.cgColor, colorB.cgColor]
        let gradlocations: [NSNumber] = [0.0, 1.0]
        let gradlayer = CAGradientLayer()
        gradlayer.colors = gradColor
        gradlayer.locations = gradlocations
        gradlayer.startPoint = CGPoint(x: 0, y: 0)
        gradlayer.endPoint = CGPoint(x: 1, y: 0)
        gradlayer.frame = frame
        gradlayer.cornerRadius = corner
        gradlayer.shadowColor = UIColor.shadowColor.cgColor
        gradlayer.shadowOffset = CGSize(width: 4, height: 10)
        gradlayer.shadowOpacity = 0.7
        gradlayer.shadowRadius = 5
        return gradlayer
    }
}



class normalGradientBtn: UIButton {
    override func draw(_ rect: CGRect) {
        let layer = CAGradientLayer.gradientLayer(frame: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height), colorA: UIColor.aleftColor, colorB: UIColor.arightColor)
        self.layer.insertSublayer(layer, at: 0)
        
    }
}
class unlockGradientBtn: UIButton {
    override func draw(_ rect: CGRect) {
        let layer = CAGradientLayer.gradientLayer(frame: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height), colorA: UIColor.aleftColor, colorB: UIColor.arightColor, corner: 33)
        self.layer.insertSublayer(layer, at: 0)
        
    }
}

class fingerGradientBtn: UIButton {
    override func draw(_ rect: CGRect) {
        let layer = CAGradientLayer.gradientLayer(frame: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height), colorA: UIColor.bLeftColor, colorB: UIColor.bLightColor, corner: 33)
        self.layer.insertSublayer(layer, at: 0)
        
    }
}

class EnrollFingerMessageLab: UILabel {
    override func draw(_ rect: CGRect) {
        let layer = CAGradientLayer.gradientLayer(frame: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height), colorA: UIColor.bLeftColor, colorB: UIColor.bLightColor, corner: 30)
        self.layer.addSublayer(layer)
    }
}

class EnrollFingerMessageBtn: UIButton {
    override func draw(_ rect: CGRect) {
        let layer = CAGradientLayer.gradientLayer(frame: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height), colorA: UIColor.bLeftColor, colorB: UIColor.bLightColor, corner: 30)
        self.layer.insertSublayer(layer, at: 0)
    }
    
}

class BGShadowView: UIView {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 6
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 2
    }
}

extension UIView {
    func genlaGradientlayer() {
        let gradColor = [UIColor.aleftColor.cgColor, UIColor.arightColor.cgColor]
        let gradlocations: [NSNumber] = [0.0, 1.0]
        let gradlayer = CAGradientLayer()
        gradlayer.colors = gradColor
        gradlayer.locations = gradlocations
        gradlayer.startPoint = CGPoint(x: 0, y: 0)
        gradlayer.endPoint = CGPoint(x: 1, y: 0)
        
        gradlayer.frame = CGRect(x: 0, y: 0, width: mScreenW - 40, height: self.bounds.size.height)
        gradlayer.cornerRadius = self.cornerRadius
        gradlayer.shadowColor = UIColor.shadowColor.cgColor
        gradlayer.shadowOffset = CGSize(width: 4, height: 2)
        gradlayer.shadowOpacity = 0.8
        gradlayer.shadowRadius = 2
        self.layer.insertSublayer(gradlayer, at: 0)
    }
}

