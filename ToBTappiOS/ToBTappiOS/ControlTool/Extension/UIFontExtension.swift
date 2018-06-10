//
//  UIFontExtension.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/10.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
extension UIFont {
    
    // 字体
    subscript (_ r: CGFloat) -> UIFont {
        let font = UIFont(name: font_name, size: r)
        return font!
    }
}
