//
//  MethodExtension.swift
//  ToBTapplcok
//
//  Created by TapplockiOS on 2018/4/12.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation

// 标准时间转16进制
func GMTCoverToHex() -> String {
    let date = Date()
    
    let str = String(describing: date) as NSString
    let s0 = str.substring(with: NSMakeRange(0, 4))
    let s1 = str.substring(with: NSMakeRange(5, 2))
    let s2 = str.substring(with: NSMakeRange(8, 2))
    let s3 = str.substring(with: NSMakeRange(11, 2))
    let s4 = str.substring(with: NSMakeRange(14, 2))
    let s5 = str.substring(with: NSMakeRange(17, 2))
    
    //
    let new = String(Int(s0)! - 1970)
    let year = new.decimalConver()?.hexadecimalSupplement()
    let month = s1.decimalConver()?.hexadecimalSupplement()
    let day = s2.decimalConver()?.hexadecimalSupplement()
    let hour = s3.decimalConver()?.hexadecimalSupplement()
    let minite = s4.decimalConver()?.hexadecimalSupplement()
    let second = s5.decimalConver()?.hexadecimalSupplement()
    let times = year! + month! + day! + hour! + minite! + second!
    
    return times
}


func hexCovertoTamp(time: String) -> Int {
    
    let xm  = time[0...3]
    let x1 = xm[0...1]
    let x2 = xm[2...3]
    
    let t1 = (x2 + x1).hexToInt!
    
    let t12 = String(t1).decimalConver(rax: 2)! as NSString
    let length = t12.length
    
    if length < 5 {
        return 1000
    }
    let d = t12.substring(with: NSMakeRange(length - 5, 5))
    
    let m = t12.substring(with: NSMakeRange(length - 9, 4))
    
    let y = t12.substring(with: NSMakeRange(0, length - 9))
    
    
    let day = d.binToDec!
    let month = m.binToDec!
    let year = y.binToDec! + 1970
    
    let t2 = time[4...5]
    let t3 = time[6...7]
    let t4 = time[8...9]
    
    let hour = t2.hexToInt!
    let mintie = t3.hexToInt!
    let second = t4.hexToInt!
    
    let date = "\(year)-\(month)-\(day) \(hour):\(mintie):\(second)"
    
//    plog(date)
    let tamp = Date.stringTimeCoverToTamp(time: date)
    return tamp
}




