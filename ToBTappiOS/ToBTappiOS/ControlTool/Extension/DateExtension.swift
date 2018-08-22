//
//  DateExtension.swift
//  Test000
//
//  Created by TapplockiOS on 2018/4/10.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
extension Date {
    


    
   static func tampCoveToString(timeStamp: Int,fomatter: String = "yyyy-MM-dd HH:mm:sss") -> String {
        let timeInterval = TimeInterval(timeStamp)
        let date1 = Date(timeIntervalSince1970: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = fomatter //自定义日期格式
        let time = dateformatter.string(from: date1)
        return time
    }
    
   static func stringTimeCoverToTamp(time: String) -> Int {
        let datefmatter = DateFormatter()
        datefmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = datefmatter.date(from: time)
        if date == nil {
            return 1522378147
        }
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateStr = Int(dateStamp)
        return dateStr
    }

    //时间戳
    var timeStemp: String {
        get {
            let stmp = Int(timeIntervalSince1970)
            return String(stmp)
        }
    }
  
}
