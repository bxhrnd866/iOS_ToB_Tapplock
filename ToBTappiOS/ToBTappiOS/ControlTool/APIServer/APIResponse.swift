//
//  APIResponse.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/6.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import Foundation
import ObjectMapper
import RxCocoa
import RxSwift
//网络请求同用响应模型
struct APIResponse<T:Mappable>: Mappable {

    var data: T?
    var message: String?
    var code: Int?
    var error: String? {
        didSet {
            if self.error == "invalid_grant" {
                ConfigModel.default.refreshToken()
            }
        }
    }
    var error_description: String?
    
    
    var codeMessage: String! {
        guard let co = code else { return "no code" }
        return APICode(code: co).rawValue
    }
    var success: Bool! {
        guard let co = code else { return false }
        if co == 0 {
            return true
        } else {
            return false
        }
    }
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        code <- map["code"]
        error <- map["error"]
        error_description <- map["error_description"]
       
    }

}

//网络请求String型响应模型
struct APIResponseString: Mappable {

    var data: String?
    var message: String?
    var code: Int?
    
    var error: String? {
        didSet {
            if self.error == "invalid_grant" {
                ConfigModel.default.refreshToken()
            }
        }
    }
    var error_description: String?
    
    var codeMessage: String! {
        guard let co = code else { return "no code" }
        return APICode(code: co).rawValue
    }
    
    var success: Bool! {
        guard let co = code else { return false }
        if co == 0 {
            return true
        } else {
            return false
        }
    }
   
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        code <- map["code"]
        error <- map["error"]
        error_description <- map["error_description"]
    }

}


struct APIResponseData<T: Mappable>: Mappable{
    
    var data: [T]?
    var message: String?
    var code: Int?
    
    var error: String? {
        didSet {
            if self.error == "invalid_grant" {
                ConfigModel.default.refreshToken()
            }
        }
    }
    var error_description: String?
    
    var codeMessage: String! {
        guard let co = code else { return "no code" }
        return APICode(code: co).rawValue
    }
    
    var success: Bool! {
        guard let co = code else { return false }
        if co == 0 {
            return true
        } else {
            return false
        }
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
        message <- map["message"]
        code <- map["code"]
        error <- map["error"]
        error_description <- map["error_description"]
    }
}

