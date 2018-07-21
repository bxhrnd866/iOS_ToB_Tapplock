//
//  EnumTools.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/21.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation

enum RequestStep {
    case none
    case loading
    case sucess
    case failed
    case errorMessage(mesg: String)
}
