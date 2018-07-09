//
//  ToAPIServer.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/9.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import Moya


enum ToAPIServer {
    case AddLock(key1: String, key2: String, mac: String, serialNo: String, userUUID: String, lockName: String, imageURL: String?)
}

extension ToAPIServer: TargetType {
    
    var headers: [String : String]? {
        let token = "Bearer " + "xxxxxxxxx"
        return ["Content-type": "application/json", "Authorization": token]
    }
    
    var baseURL: URL {
        return URL(string: APIHost + "/api/\(APIVersion)/")!
    }
    
    var path: String {
        switch self {
        case .AddLock(_, _, _, _, _, _, _):
            return "locks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .AddLock(_, _, _, _, _, _, _):
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parameters: [String: Any] = ["device": "1", "version": "v2.0"]
        
        switch self {
        case .AddLock(let key1, let key2, let mac, let serialNo, let userUUID, let lockName, let imageURL):
            return .requestCompositeData(bodyData: <#T##Data#>, urlParameters: <#T##[String : Any]#>)
        }
    }
    
  
    
    
}
