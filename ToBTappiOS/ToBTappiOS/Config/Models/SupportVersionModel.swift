//
//  SupportVersionModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/27.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import ObjectMapper

//支持版本模型,参考网络接口文档
class SupportVersionModel: Mappable {

    var maxVersionCode: String?
    var maxVersionName: String?
    var minVersionCode: String?
    var minVersionName: String?

    // MARK: JSON
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        maxVersionCode <- map["maxVersionCode"]
        maxVersionName <- map["maxVersionName"]
        minVersionCode <- map["minVersionCode"]
        minVersionName <- map["minVersionName"]
    }
}
