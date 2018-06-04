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

//用户模型,参考网络通信接口文档
class UserModel: Mappable {
    
    var basicToken: String!
    var uuid: String!
    var firstName: String!
    var lastName: String!
    var mail: String!
    var push: Bool?
    var showBattery: Bool?
    var imageUrl: String?
    
    // MARK: JSON
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        basicToken <- map["basicToken"]
        uuid <- map["uuid"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        mail <- map["mail"]
        push <- map["push"]
        showBattery <- map["showBattery"]
        imageUrl <- map["imageUrl"]
    }
    
    
}
