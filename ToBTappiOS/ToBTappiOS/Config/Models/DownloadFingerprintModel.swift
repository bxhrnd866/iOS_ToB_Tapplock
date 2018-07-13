//
//  DownloadFingerprintModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/13.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import ObjectMapper
class DownloadFingerprintModel: Mappable {
    
    var fingerprintId: Int?
    var lockId: Int?
    var templateData: String?
    
    // MARK: JSON
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        fingerprintId <- map["fingerprintId"]
        lockId <- map["lockId"]
        templateData <- map["templateData"]
    }
}
