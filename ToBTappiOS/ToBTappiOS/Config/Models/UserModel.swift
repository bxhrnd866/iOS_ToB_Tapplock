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
import CoreLocation
//用户模型,参考网络通信接口文档
class UserModel: Mappable {
    
    var accessToken: String?
    var refreshToken: String?
    var corpId: Int?
    var corpName: String?
    var entryFingerprint: Int?
    var firstName: String?
    var lastName: String?
    var groups: [GroupsModel]? {
        didSet {
            if self.groups != nil {
                let grop = GroupsModel()
                grop.groupName = R.string.localizable.allGroup()
                self.rx_groups.value = self.groups!
                self.rx_groups.value.insert(grop, at: 0)
                
                for model in groups! {
                    if groupIds == nil {
                        groupIds = String(model.id ?? -1)
                    } else {
                        groupIds = groupIds! + "," + String(model.id ?? -1)
                    }
                }
            }
        }
    }
    
    var id: Int?
    var lastLoginTime: String?
    var mail: String?
    var permissionType: Int?  // -1 MANAGER  0-ADMIN  1-MANAGER 2-USER
    var permissions: [PermissionInfoModel]?  //拥有的权限
    var phone: String?
    var photoUrl: String?
    var sex: Int?
    
    var groupIds: String?
    
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
        permissionType <- map["permissionType"]
        permissions <- map["permissions"]
        phone <- map["phone"]
        photoUrl <- map["photoUrl"]
        refreshToken <- map["refreshToken"]
        sex <- map["sex"]
    }
    
}

class AddressModel {
    var location: CLLocation?
    var address: String?
}
