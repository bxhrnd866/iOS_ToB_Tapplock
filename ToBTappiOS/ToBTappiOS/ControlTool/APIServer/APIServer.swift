//
//  APIServer.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/10.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import Foundation
import Moya

let APIHost = "http://34.220.89.68:8888"
//let APIHost = "https://api.tapplock.com"

let APIVersion = "v1"
let provider = MoyaProvider<APIServer>(plugins: [NetworkLoggerPlugin(verbose: true)])

enum APIServer {
    
    case oauthToken // 初次获取token  password client_credentials
    case userRegister(corpId: Int?, fcmDeviceToken: String?, inviteCode: String, firstName: String, lastName: String, mail: String, password: String, phone: String, photoUrl: String, sex: Int)  //0-男 1-女
    case userLog(mail: String, password: String)
    case userUpdate(fcmDeviceToken: String?, firstName: String?, groupIds: [String]?, id: String, lastName: String?, permissionIds: [Int]?, phone: String?, photoUrl: String?, sex: Int?) // 更新用户信息
    case userCheckMail(mail: String)
    case registerVerifyCode(mail: String, type: Int)  // 0-注册 1-忘记密码
    case checkVerifyCode(mail: String, verifyCode: String) // 校验验证码
    case checkinviteCodes(inviteCode: String) //校验邀请码
    case changePassword(newPassword: String, oldPassword: String)
    case lockList(lockName: String?, groupId: Int?, authType: Int?, page: Int, size: Int)  //授权类型0-蓝牙 1-指纹  锁列表
    case lockKey(lockId: Int)
    case updateLock(battery: String?, firmwareVersion: String?, hardwareVersion: String?, id: Int, latitude: String?, longitude: String?, lockName: String?, morseCode: String?, morseStatus: Int?, syncType: Int) //更新锁信息  更新类型0-地理位置 1-固件 2-其他
    case historyList(lockId: Int?, userName: String?, beginTime: Int?, endTime: Int?, queryType: Int, size: Int, page: Int)  // 查询类型(逗号分隔）0-fingerprint 1-bluetooth,2-close 3-auth bluetooth 4-auth fingerprint 5-cancel bluetooth 6-cancel fingerprint 7-location 8-firmware 9-other
    case closeTimeHistory(corpId: Int, lockId: Int, operateTime: Int) // 添加关锁记录
    case openTimeHistory(corpId: Int, latitude: String?, longitude: String?, lockId: Int, morseOperateTimes: String?, unlockFingerprints: [[String : String]]?, unlockType: Int, userId: Int)  //解锁类型0-蓝牙解锁 1-指纹解锁 2-摩斯码解锁 , "lockFingerprintIndex": "0010","operateTime": 1527064805
    case checkFirmwares(hardwareVersion: String)
    case downloadFingerprint(lockId: Int)  // 下载指纹
    case updateFingerprintSycnState(lockId: Int, fingerprintIds: Int, lockFingerprintIndex: String) // 更新指纹同步状态
    case feedBack(content: String, title: String, corpId: Int, source: Int, platform: Int) // 反馈

}

extension APIServer: TargetType{
    
    var headers: [String : String]? {
        var token = "Bearer "
        
        if basicToken_UserKey != nil {
            token = "Bearer " + basicToken_UserKey!
        }
        
        switch self {
        case .registerVerifyCode:
            return ["Content-type": "application/json", "Authorization": token, "lang": ConfigModel.default.language.code]
        default:
            return ["Content-type": "application/json", "Authorization": token]
        }
    }
    
    var baseURL: URL {
        return URL(string: APIHost + "/api/\(APIVersion)/")!
    }
    
    
    var path: String {
        switch self {
        case .userRegister(_, _, _, _, _, _, _, _, _, _):
            return "users/register"
        case .userLog(_, _):
            return "users/login"
        case .userUpdate(_, _, _, _, _, _, _, _, _):
            return "users"
        case .registerVerifyCode(_, _):
            return "users/get_verify_code"
        case .lockList(_, _, _, _, _):
            return "locks/for_staff"
        case .lockKey(let id):
            return "locks/\(id)"
        case .updateLock(_, _, _, _, _, _, _, _, _, _):
            return "locks"
        case .historyList(_, _, _, _, _, _, _):
            return "lock_histories"
        case .closeTimeHistory(_, _, _):
            return "lock_histories/close"
        case .openTimeHistory(_, _, _, _, _, _, _, _):
            return "lock_histories/open"
        case .oauthToken:
            return "oauth/token"
        case .downloadFingerprint(_):
            return "auth_rels/to_be_downloaded"
        case .updateFingerprintSycnState(_, _, _):
            return "auth_rels/update_rel"
        case .changePassword(_, _):
            return "users/change_password"
        case .feedBack(_, _, _, _, _):
            return "feedback"
        case .checkinviteCodes(_):
            return "invite_codes/check_invite"
        case .checkVerifyCode(_, _):
            return "users/check_verify_code"
        case .checkFirmwares(let hardwareVersion):
            return "firmwares/\(ConfigModel.default.language.code)/\(hardwareVersion)"
        case .userCheckMail(_):
            return "users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .lockList(_, _, _, _, _),
             .lockKey(_),
             .historyList(_, _, _, _, _, _, _),
             .registerVerifyCode(_, _),
             .downloadFingerprint(_),
             .checkinviteCodes(_),
             .checkFirmwares(_),
             .userCheckMail(_),
             .checkVerifyCode(_, _):
            return .get
        case .updateLock(_, _, _, _, _, _, _, _, _, _),
             .updateFingerprintSycnState(_, _, _),
             .userUpdate(_, _, _, _, _, _, _, _, _),
             .changePassword(_, _):
            return .put
        case .closeTimeHistory(_, _, _),
             .openTimeHistory(_, _, _, _, _, _, _, _),
             .oauthToken,
             .userRegister(_, _, _, _, _, _, _, _, _, _),
             .userLog(_, _),
             .feedBack(_, _, _, _, _):
            return .post
            
        }
    }
    
    var task: Task {
        
        var parameters: [String: Any] = ["device": "1", "version": "v2.0"] + hmacSign()
        
        var dict = [String: Any]()
        
        switch self {
            
        case .userRegister(let corpId, let fcmDeviceToken, let inviteCode, let firstName, let lastName, let mail, let password, let phone, let photoUrl, let sex):
            
            if fcmDeviceToken != nil {
                dict = dict + ["fcmDeviceToken": fcmDeviceToken!]
            }
            if corpId != nil {
                dict = dict + ["corpId": corpId!]
            }
            
            dict = dict + ["phone": phone, "inviteCode": inviteCode, "firstName": firstName, "lastName": lastName, "mail": mail, "password": password, "photoUrl": photoUrl, "sex": sex]
            let data = requestBodyEncrypted(body: dict)
            
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
            
        case .userLog(let mail, let password):
            
            dict = dict + ["mail": mail, "password": password, "clientType": 1]
            let data = requestBodyEncrypted(body: dict)
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
        case .userCheckMail(let mail):
            parameters = parameters + ["mail": mail]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
            
        case .oauthToken:
           
            dict = dict + ["grant_type": "client_credentials"]
            
            let data = requestBodyEncrypted(body: dict)
            
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
            
        case .registerVerifyCode(let type, let mail):
            
            parameters = parameters + ["type": type, "mail": mail]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
            
        case .lockList(let lockName, let groupId, let authType, let page, let size):
            
            if lockName != nil {
                parameters = parameters + ["lockName": lockName!]
            }
            
            if groupId != nil {
                parameters = parameters + ["groupId": groupId!]
            }
            if authType != nil {
                parameters = parameters + ["authType": authType!]
            }
            
            parameters = parameters + ["page": page, "size": size, "userId": (ConfigModel.default.user.value?.id)!, "corpId": (ConfigModel.default.user.value?.corpId)!]
            
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
            
        case .lockKey(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
        case .updateLock(let battery, let firmwareVersion, let hardwareVersion, let id, let latitude, let longitude, let lockName, let morseCode, let morseStatus, let syncType):
            
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
        
            dict = dict + ["id": id, "syncType": syncType]
            
            let data = requestBodyEncrypted(body: dict)
            
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
            
        case .historyList(let lockId, let userName, let beginTime, let endTime, let queryType, let size, let page):
            
           
            if userName != nil {
                parameters = parameters + ["userName": userName!]
            }
            if beginTime != nil {
                parameters = parameters + ["beginTime": beginTime!]
            }
            if endTime != nil {
                parameters = parameters + ["endTime": endTime!]
            }
            
            if lockId != nil {
                 parameters = parameters + ["lockId": lockId!]
            }
            
            parameters = parameters + ["queryType": queryType, "page": page, "size": size]
            
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
            
        case .closeTimeHistory(let corpId, let lockId, let operateTime):
            dict = dict + ["corpId": corpId, "lockId": lockId, "operateTime": operateTime]
            let data = requestBodyEncrypted(body: dict)
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
            
        case .openTimeHistory(let corpId, let latitude, let longitude, let lockId, let morseOperateTimes, let unlockFingerprints, let unlockType, let userId):
            
            if latitude != nil {
                dict = dict + ["latitude": latitude!]
            }
            if longitude != nil {
                dict = dict + ["longitude": longitude!]
            }
            if morseOperateTimes != nil {
                dict = dict + ["morseOperateTimes": morseOperateTimes!]
            }
            if unlockFingerprints != nil {
                dict = dict + ["unlockFingerprints": unlockFingerprints!]
            }
            if longitude != nil {
                dict = dict + ["longitude": longitude!]
            }
            
            dict = dict + ["corpId": corpId, "lockId": lockId, "userId": userId, "unlockType": unlockType]
            
            let data = requestBodyEncrypted(body: dict)
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
            
        case .downloadFingerprint(let lockId):
            parameters = parameters + ["lockId": lockId]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
            
        case .updateFingerprintSycnState(let lockId, let fingerprintIds, let lockFingerprintIndex):
            parameters = parameters + ["lockId": lockId, "fingerprintIds": fingerprintIds, "lockFingerprintIndex": lockFingerprintIndex]
            
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
            
        case .userUpdate(let fcmDeviceToken, let firstName, let groupIds, let id, let lastName, let permissionIds, let phone, let photoUrl, let sex):
            
            if fcmDeviceToken != nil {
                dict = dict + ["fcmDeviceToken": fcmDeviceToken!]
            }
            if firstName != nil {
                dict = dict + ["firstName": firstName!]
            }
            if groupIds != nil {
                dict = dict + ["groupIds": groupIds!]
            }
            if lastName != nil {
                dict = dict + ["lastName": lastName!]
            }
            if permissionIds != nil {
                dict = dict + ["permissionIds": permissionIds!]
            }
            if phone != nil {
                dict = dict + ["phone": phone!]
            }
            if photoUrl != nil {
                dict = dict + ["photoUrl": photoUrl!]
            }
            if sex != nil {
                dict = dict + ["sex": sex!]
            }
            
            dict = dict + ["id": id]
            let data = requestBodyEncrypted(body: dict)
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
            
        case .changePassword(let newPassword, let oldPassword):
            dict = dict + ["newPassword": newPassword, "oldPassword": oldPassword, "id": (ConfigModel.default.user.value?.id)!]
            let data = requestBodyEncrypted(body: dict)
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
        
        case .feedBack(let content, let title, let corpId, let source, let platform):
            dict = dict + ["userId": (ConfigModel.default.user.value?.id)!, "content": content, "title": title, "corpId": corpId, "source": source, "platform": platform]
            let data = requestBodyEncrypted(body: dict)
            return .requestCompositeData(bodyData: data, urlParameters: parameters)
        
        case .checkinviteCodes(let inviteCode):
            parameters = parameters + ["inviteCode": inviteCode]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
        
        case .checkVerifyCode(let mail, let verifyCode):
            parameters = parameters + ["mail": mail, "verifyCode": verifyCode]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
        
        case .checkFirmwares(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
        }
        
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    
}
