//
//  Users.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/5/15.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import Moya_ObjectMapper
import ObjectMapper
import RxCocoa
import RxSwift
//用户模型,参考网络通信接口文档
class UserModel: Mappable {
    
    var accessToken: String?
    var corpId: Int?
    var corpName: String?
    var entryFingerprint: Int?
    var firstName: String?
    var lastName: String?
    var groups: [GroupsModel]? {
        didSet {
            if groups != nil {
                rx_groups.value = groups!
            }
        }
    }
    var id: Int?
    var lastLoginTime: String?
    var mail: String?
    var master: Int?
    var permissionType: Int?  //0-ADMIN 1-MANAGER 2-USER
    var permissions: [PermissionInfoModel]?  //拥有的权限
    var phone: String?
    var photoUrl: String?
    var refreshToken: String?
    var sex: Int?
    
    var rx_groups: Variable<[GroupsModel]> = Variable([GroupsModel]())
    
    
    // MARK: JSON
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        accessToken <- map["accessToken"]
        corpId <- map["corpId"]
        corpName <- map["corpName"]
        entryFingerprint <- map["entryFingerprint"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        groups <- map["groups"]
        id <- map["id"]
        lastLoginTime <- map["lastLoginTime"]
        mail <- map["mail"]
        master <- map["master"]
        permissionType <- map["permissionType"]
        permissions <- map["permissions"]
        phone <- map["phone"]
        photoUrl <- map["photoUrl"]
        refreshToken <- map["refreshToken"]
        sex <- map["sex"]
    }
    
}
