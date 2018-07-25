//
//  GroupsModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/11.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import Moya_ObjectMapper
import ObjectMapper
class GroupsModel: Mappable {
    
    var groupName: String?
    var id: Int?
    
    // MARK: JSON
    required init?(map: Map) {
        
    }
    init() {
        
    }
    
    func mapping(map: Map) {
        groupName <- map["groupName"]
        id <- map["id"]
    }
}
