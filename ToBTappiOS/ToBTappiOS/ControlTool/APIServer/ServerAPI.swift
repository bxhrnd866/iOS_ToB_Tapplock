//
//  ServerAPI.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/9.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import Moya

enum ServerAPI {
    case LockList(lockName: String? , corpId: Int?, groupId: Int?, authType: Int?, page: Int, size: Int)  //授权类型0-蓝牙 1-指纹
    case UpdateLock(battery: String?, firmwareVersion: String?, hardwareVersion: String?, id: Int, latitude: String?, longitude: String?, lockName: String?, morseCode: String?, morseStatus: Int?)
}

extension ServerAPI: TargetType{
    
    var headers: [String : String]? {
        let token = "Bearer " + "xxxxxxxxx"
        return ["Content-type": "application/json", "Authorization": token]
    }
    
    var baseURL: URL {
        return URL(string: APIHost + "/api/\(APIVersion)/")!
    }
    
    var path: String {
        switch self {
        case .LockList(_, _, _, _, _, _):
            return "locks/for_staff"
        case .UpdateLock(_, _, _, _, _, _, _, _, _):
            return "locks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .LockList(_, _, _, _, _, _):
            return .get
        case .UpdateLock(_, _, _, _, _, _, _, _, _):
            return .put
        }
    }
    
    
    var task: Task {
        
        let parameters: [String: Any] = ["device": "1", "version": "v2.0"] + hmacSign()
        
        var dict = [String: Any]()
        
        switch self {
        case .LockList(let lockName, let corpId, let groupId, let authType, let page, let size):
            
            if lockName != nil {
                dict = dict + ["lockName": lockName!]
            }
            if corpId != nil {
                dict = dict + ["corpId": corpId!]
            }
            if groupId != nil {
                dict = dict + ["groupId": groupId!]
            }
            if authType != nil {
                dict = dict + ["authType": authType!]
            }
        
            dict = dict + ["page": page, "size": size, "userId": (ConfigModel.default.user.value?.uuid)!]
            
            let data = requestBodyEncrypted(body: dict)
            
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
            
        case .UpdateLock(let battery, let firmwareVersion, let hardwareVersion, let id, let latitude, let longitude, let lockName, let morseCode, let morseStatus):
            
            if battery != nil {
                dict = dict + ["battery": battery!]
            }
            if firmwareVersion != nil {
                dict = dict + ["firmwareVersion": firmwareVersion!]
            }
            if hardwareVersion != nil {
                dict = dict + ["hardwareVersion": hardwareVersion!]
            }
            if latitude != nil {
                dict = dict + ["latitude": latitude!]
            }
            if longitude != nil {
                dict = dict + ["longitude": longitude!]
            }
            if lockName != nil {
                dict = dict + ["lockName": lockName!]
            }
            if morseCode != nil {
                dict = dict + ["morseCode": morseCode!]
            }
            if morseStatus != nil {
                dict = dict + ["morseStatus": morseStatus!]
            }
            dict = dict + ["id": id]
            
            let data = requestBodyEncrypted(body: dict)
            
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
            
            
        }
    }
   
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    
}
