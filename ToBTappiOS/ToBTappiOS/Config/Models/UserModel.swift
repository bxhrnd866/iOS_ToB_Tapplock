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
    
    var accessToken: String? {
        didSet {
            UserDefaults.standard.set(accessToken, forKey: n_basicToKenKey)
        }
    }
    var refreshToken: String? {
        didSet {
            UserDefaults.standard.set(refreshToken, forKey: n_refreshTokenKey)
        }
    }
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
    var sex: Int?
    
    var rx_groups: Variable<[GroupsModel]> = Variable([GroupsModel]())
    
    var meunSoure: [String]! {
        
        let x = "View All Locks"
        let y = "View History"
        
        var data =  ["Profile","Tapplock","Tutorial","Setting","Log out"]
        if permissions != nil {
            for item in permissions! {
                if item.permissionCode == "301" {
                    data.insert(x, at: 2)
                }
                
                if item.permissionCode == "302" {
                    if data[2] == x {
                        data.insert(y, at: 3)
                    } else {
                        data.insert(y, at: 2)
                    }
                }
            }
        }
        
        return data
    }
    
    
    
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

class AddressModel {
    var location: CLLocation?
    var address: String?
}
