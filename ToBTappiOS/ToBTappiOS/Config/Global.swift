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
import Cloudinary
import Kingfisher
import SwiftDate

func plog<T>(_ message: T,
             fileName: String = #file,
             methodName: String = #function,
             lineNumber: Int = #line){
    #if DEBUG
    print("\((fileName as NSString).pathComponents.last!).\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

//isSimulator,开发时用
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

let isPhoneX = UIScreen.main.currentMode?.size.height == 2436

let TopBarHeight: CGFloat = isPhoneX ? 88 : 64

let BottomBarHeight: CGFloat = isPhoneX ? 83 : 49 //底部有tabbar高度

let StatusBarHeight: CGFloat = isPhoneX ? 44 : 20 //状态栏高度

let kSafeAreaInset = isPhoneX ? 34 : 0

let kNoStatusBar = isPhoneX ? 44 : 0

let thembColor = UIColor("#ED6332")

let mScreenH = UIScreen.main.bounds.height

let mScreenW = UIScreen.main.bounds.width

let mScale = mScreenW/375

let font_name = "Century Gothic"

let isIphone5 = mScreenW <= 320

// MARK: key

let ble_notficationKye = "ble_notficationKye_Response"

let ble_disconnectKey = "ble_disconnectKeyDisconnect"

let notificaitonName_postDFUUpate = "notificaitonName_postDFUUpate"

let language_model_key = "language_model_key"




let key_basicToken = "basicTokenUserDefaultKey"

let key_refreshToken = "refreshbasicTokenUserDefaultKey"




let cldConfiguration = CLDConfiguration.init(cloudName: "tapplock", apiKey: "98584592923587")

let cloudinaryStorage = CLDCloudinary.init(configuration: cldConfiguration)

let kfProcessor = CroppingImageProcessor(size: CGSize(width: 300, height: 300), anchor: CGPoint(x: 0.5, y: 0.5)) >> RoundCornerImageProcessor(cornerRadius: 150)
