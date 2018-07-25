//
//  LockHistoryModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/13.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import ObjectMapper

class LockHistoryModel: Mappable {
    
    var firstName: String?
    var lastName: String?
    var historyType: Int?      //历史记录类型0-指纹开锁 1-蓝牙开锁 ,
    var latitude: String?
    var longitude: String?
    var location: String?
    var lockName: String?
    var mail: String?
    var imageUrl: String?
    
    
    var operateTime: String? {
        didSet {
            let date = Date.init(timeIntervalSince1970: (Double(operateTime ?? "0") ?? 0))
            self.textTime = "\(date.year)" + "-" + "\(date.month)"
        }
    } //操作时间
    var operatorFirstName: String?  // 操作人名字
    var operatorLastName: String?   //操作人姓氏
    var textTime: String? //2018-09
    
    
    
    // MARK: JSON
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        historyType <- map["historyType"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        location <- map["location"]
        lockName <- map["lockName"]
        operateTime <- map["operateTime"]
        mail <- map["mail"]
        operatorFirstName <- map["operatorFirstName"]
        operatorLastName <- map["operatorLastName"]
        imageUrl <- map["imageUrl"]
    }
}
