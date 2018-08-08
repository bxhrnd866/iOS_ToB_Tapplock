//
//  SearchBar.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class SearchBar: UIView, UITextFieldDelegate {
    
    private var field: SerchTextField!
    private var cancelBtn: UIButton!
    var rx_text: Variable<String?> = Variable(nil)
    var rx_action: Variable<Bool> = Variable(false)
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        field = SerchTextField(frame: CGRect(x: mScreenW - 70, y: 9, width: 0, height: 26))
        field.layer.cornerRadius = 13
        field.layer.masksToBounds = true
        field.returnKeyType = .search
        field.delegate = self
        field.rx.text.bind(to: rx_text).disposed(by: rx.disposeBag)
        
        
        self.addSubview(field)
        
        cancelBtn = UIButton(frame: CGRect(x: field.rightX, y: 0, width: 70, height: self.height))
        cancelBtn.setTitle(R.string.localizable.cancel(), for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: font_name, size: 15)
        
        cancelBtn.rx.tap.subscribe(onNext: { [weak self]  in
            self?.cancelHidde()
        
        }).disposed(by: rx.disposeBag)
        
    
        self.addSubview(cancelBtn)
    
        self.backgroundColor = UIColor.themeColor
        
        cancelHidde()
    }
    
    func serchShow() {
        self.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.field.frame = CGRect(x: 20, y: 9, width: mScreenW - 20 - 50 - 20, height: 26)
        }) { bl in
            
        }
        UIView.animate(withDuration: 0.6, animations: {
            self.cancelBtn.transform = CGAffineTransform.identity
        })
    }
    
    func cancelHidde() {
        rx_action.value = false
        field.frame =  CGRect(x: mScreenW - 70, y: 9, width: 0, height: 26)
        cancelBtn.transform = CGAffineTransform.init(translationX: mScreenW, y: 0)
        self.isHidden = true
        field.resignFirstResponder()
        field.text = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if canSearch() {
            rx_action.value = true
        }
        textField.resignFirstResponder()
        return true
    }
    
    private func canSearch() -> Bool {
        if self.field.text == nil {
            return false
        }
        if (field.text?.containsEmoji)! {
            return false
        }
        return true
    }
}


class SerchTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tintColor = UIColor.themeColor
        let left = UIImageView(image: R.image.naivsearch())
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

