//
//  AppVersionModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/8/20.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation

import ObjectMapper

//支持版本模型,参考网络接口文档
class AppVersionModel: Mappable {
    
    var appType: Int?
    var currentVersion: String?
    var releaseTime: Int?
    var supportMinVersion: String?
    
    // MARK: JSON
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        appType <- map["appType"]
        currentVersion <- map["currentVersion"]
        releaseTime <- map["releaseTime"]
        supportMinVersion <- map["supportMinVersion"]
    }
}
