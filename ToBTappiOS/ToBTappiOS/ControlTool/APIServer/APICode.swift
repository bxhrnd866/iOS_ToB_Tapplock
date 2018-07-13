//
//  APICode.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/13.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation

enum APICode {
    
    case aa
    case bb
    
    init?(_ code: Int) {
        switch code {
        case 1001:
            self = .bb
        case 1002:
            self = .aa
        default:
            return nil
        }
    }
    
    var rawValue: String? {
        switch self {
        case .aa:
            return "xxxxx"
        case .bb:
            return "ggggg"
        default:
            return nil
        }
    }

}
