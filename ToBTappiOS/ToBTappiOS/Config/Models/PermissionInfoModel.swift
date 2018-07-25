//
//  PermissionInfoModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/11.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation

import Moya_ObjectMapper
import ObjectMapper

class PermissionInfoModel: Mappable {
    
    var authority: String?
    var id: Int?  //权限
    var permissionCode: String?  //权限代码
    var permissionDesc: String?  //权限描述
    var permissionType: Int? // 权限类型0-admin 1-operational 2-user app
    
    var permissionName: String? {
        if permissionCode == nil {
            return nil
        }
        let num = permissionCode!.toInt()
        
        return APICode.init(num ?? -100).rawValue
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        authority <- map["authority"]
        id <- map["id"]
        permissionCode <- map["permissionCode"]
        permissionDesc <- map["permissionDesc"]
        permissionType <- map["permissionType"]
    }
}
