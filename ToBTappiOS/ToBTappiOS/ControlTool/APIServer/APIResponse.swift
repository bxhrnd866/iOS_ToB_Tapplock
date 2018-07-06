//
//  APIResponse.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/6.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import Foundation
import ObjectMapper

//网络请求同用响应模型
struct APIResponse<T:Mappable>: Mappable {

    var data: T?
    var message: String?
    var devMessage: String?
    var success: Bool! = false

    // MARK: JSON
    static func errorResponse() -> APIResponse {
        return APIResponse.init()
    }

    private init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        success <- map["status"]
    }

}

//网络请求String型响应模型
struct APIResponseString: Mappable {

    var data: String?
    var message: String?
    var devMessage: String?
    var success: Bool! = false

    // MARK: JSON
    static func errorResponse() -> APIResponseString {
        return APIResponseString.init()
    }

    private init() {
    }

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        success <- map["status"]
    }

}

