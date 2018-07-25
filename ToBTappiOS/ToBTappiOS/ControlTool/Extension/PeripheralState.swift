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

var cbLockid = "cbLockid"
extension CBPeripheral {
    var lockId: Int? {
        get {
            return (objc_getAssociatedObject(self, &cbLockid) as? Int)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &cbLockid, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
