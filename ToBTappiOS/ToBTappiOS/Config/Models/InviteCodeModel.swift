//
//  InviteCodeModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/30.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import ObjectMapper

//支持版本模型,参考网络接口文档
class InviteCodeModel: Mappable {
    
    var corpId: Int?
    var corpName: String?
    var groups: [GroupsModel]?
    var isMasterCode: Int?
    
    // MARK: JSON
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        corpId <- map["corpId"]
        corpName <- map["corpName"]
        groups <- map["groups"]
        isMasterCode <- map["isMasterCode"]
    }
}
