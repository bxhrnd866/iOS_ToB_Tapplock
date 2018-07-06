//
//  APIServer.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/5.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import Foundation
import Moya

let APIVersion = "v1"

let APIHost = "http://192.168.7.213:8791"
//let APIHost = "https://api.tapplock.com"

let provider = MoyaProvider<ApiService>(plugins: [NetworkLoggerPlugin(verbose: true)])

//定义各种网络接口
enum ApiService {
    case Login(mail: String, password: String)

}

//设置各种网络接口
extension ApiService: TargetType {

    var headers: [String: String]? {
        let token = "Bearer " + "xxxxxxxxx"
         return ["Content-type": "application/json", "Authorization": token]
    }

    var baseURL: URL {
        return URL(string: APIHost + "/api/\(APIVersion)/")!
    }

    var path: String {
        switch self {
        case .Login(_, _):
            return "users/actions/login"
        }
    }

    
    var method: Moya.Method {
        switch self {
        case .Login(_, _):
            return .post
//            return .get
//            return .delete
//            return .put
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    var task: Task {//parameters
        let parameters: [String: Any] = ["device": "1", "version": "v2.0"]

        switch self {
        case .Login(let mail, let password):
            let data = requestBodyEncrypted(body: ["mail": mail, "password": password] + parameters)
            return .requestCompositeData(bodyData: data, urlParameters: hmacSign())
        }
    }
}

