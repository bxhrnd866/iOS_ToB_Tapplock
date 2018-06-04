//
//  Global.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/5/15.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift


func plog<T>(_ message: T,
             fileName: String = #file,
             methodName: String = #function,
             lineNumber: Int = #line){
    #if DEBUG
    print("\((fileName as NSString).pathComponents.last!).\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

let thembColor = UIColor("#66666")

let mScreenH = UIScreen.main.bounds.height

let mScreenW = UIScreen.main.bounds.width



// MARK: key

let ble_notficationKye = "ble_notficationKye_Response"

let ble_disconnectKey = "ble_disconnectKeyDisconnect"

let language_model_key = "language_model_key"

let user_saveKey = "user_saveKey"

