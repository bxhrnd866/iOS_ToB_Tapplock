//
//  FingerprintHistoryModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/20.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import Foundation
import ObjectMapper

//指纹历史模型,参考网络通信接口文档
class FingerprintHistoryModel: Mappable {
    
    var fingerOwnerName: String!
    var lockName: String!
    var closeTime: Int?
    var openTime: Int? {
        didSet {
            let date = Date.init(timeIntervalSince1970: (Double(self.openTime ?? 0)))
            self.day = "\(date.year)" + "-" + "\(date.month)"
        }
    }
    
    var day: String?
    
    // MARK: JSON
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        fingerOwnerName <- map["fingerOwnerName"]
        lockName <- map["lockName"]
        openTime <- map["openTime"]
        closeTime <- map["closeTime"]
    }
    
}
