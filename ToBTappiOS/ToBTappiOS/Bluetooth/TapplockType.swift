//
//  TapplockType.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/3/28.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import Foundation

let aKind = "0001"
let bKind = "0002"

// 设备类型
enum TapplockType: String {
    case typeA = "0001"
    case typeB = "0100"
    case typeC = "0002"
    case typeD = "0200"
    
    var deviceType: String! {
        switch self {
        case .typeA,.typeB:
            return aKind
        case .typeC,.typeD:
            return bKind
        }
    }
    
}

