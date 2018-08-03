
//
//  FingerPrintModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/24.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import ObjectMapper

class FingerPrintModel: Mappable {
    
    var fingerType: Int?
    var handType: Int?
    var id: String?
    var sn: String?
    var finger: Finger {
        get {
            return Finger(rawValue: self.fingerType!)!
        }
    }
    
    // MARK: JSON
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        fingerType <- map["fingerType"]
        handType <- map["handType"]
        id <- map["id"]
        sn <- map["sn"]
    }
}
