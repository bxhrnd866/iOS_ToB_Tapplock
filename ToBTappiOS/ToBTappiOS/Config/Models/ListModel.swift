//
//  ListModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/7.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import Foundation
import ObjectMapper
//通用列表模型,参考网络通信接口文档
class ListModel<T:Mappable>: Mappable {

    var list: Array<T>!
    var totalCount: Int?
    var totalPage: Int?
    var pageCurrent: Int?
    var pageSize: Int?

    // MARK: JSON
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        list <- map["list"]
        totalCount <- map["totalCount"]
        totalPage <- map["totalPage"]
        pageCurrent <- map["pageCurrent"]
        pageSize <- map["pageSize"]
    }

}
