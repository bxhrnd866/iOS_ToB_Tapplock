//
//  DictionaryExtension.swift
//  ToBTapplcok
//
//  Created by TapplockiOS on 2018/5/11.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
extension Dictionary {
    static func +(left: Dictionary, right: Dictionary) -> Dictionary {
            var dic = left
            for (key, value) in right {
                dic[key] = value
            }
            return dic
    }
}
