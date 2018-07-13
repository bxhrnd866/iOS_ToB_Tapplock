//
//  FirmwareModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/13.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import ObjectMapper

class FirmwareModel: Mappable {
    
    var currentVersion: String?
    var firmwarePackageUrl: String?
    var firmwareSize: String?
    var hardwareVersion: String?
    var supportMinVersion: String?
    var updateContent: String?
    var updateTime: Int?
    
    
    
    // MARK: JSON
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        currentVersion <- map["currentVersion"]
        firmwarePackageUrl <- map["firmwarePackageUrl"]
        firmwareSize <- map["firmwareSize"]
        hardwareVersion <- map["hardwareVersion"]
        supportMinVersion <- map["supportMinVersion"]
        updateContent <- map["updateContent"]
        updateTime <- map["updateTime"]
    }
}
