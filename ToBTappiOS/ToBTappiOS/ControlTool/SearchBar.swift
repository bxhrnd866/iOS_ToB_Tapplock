//
//  SearchBar.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class SearchBar: UIView {
    
    private var field: SerchTextField!
    private var cancelBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        field = SerchTextField(frame: CGRect(x: 25, y: 9, width: self.width - 25 - 50 - 20, height: 26))
        field.layer.cornerRadius = 13
        field.layer.masksToBounds = true
        self.addSubview(field)
        
        cancelBtn = UIButton(frame: CGRect(x: field.rightX, y: 0, width: 50, height: self.height))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.red, for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: font_name, size: 15)
        self.addSubview(cancelBtn)
        
        self.backgroundColor = UIColor.themeColor
        
        cancelHidde()
    }
    
    func serchShow() {
        UIView.animate(withDuration: 0.5, animations: {
            self.field.transform = CGAffineTransform.identity
        }) { bl in
            UIView.animate(withDuration: 0.2, animations: {
                self.cancelBtn.transform = CGAffineTransform.identity
            })
        }
    }
    
    func cancelHidde() {
        field.transform = CGAffineTransform.init(scaleX: 0.01, y: 1)
        cancelBtn.transform = CGAffineTransform.init(scaleX: 0.01, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


class SerchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tintColor = UIColor.themeColor
        let left = UIImageView(image: R.image.home_search())
        left.backgroundColor = UIColor.red
        self.leftView = left
        self.leftViewMode = .always
        self.backgroundColor = UIColor.white
        self.font = UIFont.init(name: font_name, size: 14)
        self.placeholder = "输入锁的名字"
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 10
        return rect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 30, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 30, dy: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

