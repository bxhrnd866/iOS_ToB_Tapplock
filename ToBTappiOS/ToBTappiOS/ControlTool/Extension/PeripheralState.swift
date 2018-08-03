//
//  PeripheralState.swift
//  Test000
//
//  Created by TapplockiOS on 2018/4/10.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import CoreBluetooth

// 多语言
extension CBPeripheralState {
    var textValue: String {
        switch self {
        case .connected:
            return R.string.localizable.connected()
        default:
            return R.string.localizable.disconnected()
        }
    }
    
}

var mactext = "mactext"
extension CBPeripheral {
    var mac: String? {
        get {
            return (objc_getAssociatedObject(self, &mactext) as? String)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &mactext, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
