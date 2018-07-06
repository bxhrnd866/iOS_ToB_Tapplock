//
//  BluetoothHistoryModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/19.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import Foundation
import ObjectMapper

//蓝牙历史模型,参考网络通信接口文档
class BluetoothHistoryModel: Mappable {
    
    var firstName: String?
    var imageUrl: String?
    
    var location: String?
    var lockName: String?
    var timeText: String? {
        didSet {
            let date = Date.init(timeIntervalSince1970: (Double(timeText ?? "0") ?? 0))
            self.day = "\(date.year)" + "-" + "\(date.month)"
        }
    }
    
    var day: String?
    
    
    // MARK: JSON
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        firstName <- map["firstName"]
        imageUrl <- map["imageUrl"]
        location <- map["location"]
        lockName <- map["lockName"]
        timeText <- map["timeText"]
    }
    
}
