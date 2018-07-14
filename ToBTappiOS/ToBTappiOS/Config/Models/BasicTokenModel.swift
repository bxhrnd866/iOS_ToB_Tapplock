//
//  BasicTokenModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/14.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import ObjectMapper
class BasicTokenModel: Mappable{
    
    var access_token: String?
    var token_type: String?
    var expires_in: Int?
    var scope: String?
    
    
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        access_token <- map["access_token"]
        token_type <- map["token_type"]
        expires_in <- map["expires_in"]
        scope <- map["scope"]
       
    }
    
}
