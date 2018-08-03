//
//  FingerprintDataModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/30.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import ObjectMapper

//支持版本模型,参考网络接口文档
class FingerprintDataModel: Mappable {
    
    var fingerprintId: Int?
    var lockFingerprintIndex: String?
    var lockId: String?
    var syncType: Int?   // 0下载 1 删除
    var templateData: String?   // 数据

    
    // MARK: JSON
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        fingerprintId <- map["fingerprintId"]
        lockFingerprintIndex <- map["lockFingerprintIndex"]
        lockId <- map["lockId"]
        syncType <- map["syncType"]
        templateData <- map["templateData"]
    }
}
