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
    var accessType: Int?      //0-蓝牙 1-指纹 2-摩斯码 3-关锁
    var latitude: String?
    var longitude: String?
    var location: String? {
        didSet {
            let text = self.location ?? "xxxx"
            
            let size = text.boundingRect(with: CGSize(width: mScreenW - 125, height: 1000), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)], context: nil).size
            self.cellHeight = size.height + 10
        }
    }
    var lockName: String?
    var mail: String?
    var photoUrl: String?
    
    var operateTime: Int? {
        didSet {
            
            let timeInterval:TimeInterval = TimeInterval(self.operateTime ?? 0)
            let date = Date(timeIntervalSince1970: timeInterval)
            self.textTime = "\(date.year)" + "-" + "\(date.month)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.timeDate = dateFormatter.string(from: date)
            
        }
    } //操作时间
    
    
   
    var cellHeight: CGFloat?
    
    
    var textTime: String? //2018-09
    
    var timeDate: String?
    
    
    // MARK: JSON
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        accessType <- map["accessType"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        location <- map["location"]
        lockName <- map["lockName"]
        operateTime <- map["operateTime"]
        mail <- map["mail"]
        photoUrl <- map["photoUrl"]
    }
}
