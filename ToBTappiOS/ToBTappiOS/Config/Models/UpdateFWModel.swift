//
//  UpdateFirmwareModel.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/3/26.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import UIKit
import ObjectMapper
//支持版本模型,参考网络接口文档

class UpdateFWModel: Mappable {
    var currentVersion: String?
    var firmwarePackageUrl: String?
    var firmwareSize: String?
    var supportMinVersion: String?
    var updateTime: String?
    var updateContent: String?
    
    
    
    // MARK: JSON
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {

        currentVersion <- map["currentVersion"]
        firmwarePackageUrl <- map["firmwarePackageUrl"]
        firmwareSize <- map["firmwareSize"]
        supportMinVersion <- map["supportMinVersion"]
        updateTime <- map["updateTime"]
        updateContent <- map["updateContent"]
    }
    
    
}
