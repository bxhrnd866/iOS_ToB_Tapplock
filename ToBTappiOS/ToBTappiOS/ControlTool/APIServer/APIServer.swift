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

let APIHost = "http://192.168.7.213:8791"
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
    
        switch self {
        case .oauthToken:
            let value = "clientIdPassword:secret".toBase64()
            return ["Content-type": "application/json", "Authorization": "Basic \(value)"]
        case .registerVerifyCode:
           
            return ["Content-type": "application/json", "Authorization": "Bearer " + (basicToken_UserKey ?? "ggggg"), "lang": ConfigModel.default.language.code]
        default:
            return ["Content-type": "application/json", "Authorization": "Bearer " + (basicToken_UserKey ?? "ggggg")]
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
//        + hmacSign()
        var urlParameters = [String: Any]()
        
        var bodyParameters = [String: Any]()
        
        switch self {
            
        case .userRegister(let corpId, let fcmDeviceToken, let inviteCode, let firstName, let lastName, let mail, let password, let phone, let photoUrl, let sex):
            
            if fcmDeviceToken != nil {
                bodyParameters = bodyParameters + ["fcmDeviceToken": fcmDeviceToken!]
            }
            if corpId != nil {
                bodyParameters = bodyParameters + ["corpId": corpId!]
            }

            bodyParameters = bodyParameters + ["phone": phone, "inviteCode": inviteCode, "firstName": firstName, "lastName": lastName, "mail": mail, "password": password.sha256(), "photoUrl": photoUrl, "sex": sex]
            let data = requestBodyEncrypted(body: bodyParameters)
            
            return .requestCompositeData(bodyData: data, urlParameters: urlParameters)
            
        case .userLog(let mail, let password):
            
            bodyParameters = bodyParameters + ["mail": mail, "password": password.sha256(), "clientType": 1]
            let data = requestBodyEncrypted(body: bodyParameters)
            return .requestCompositeData(bodyData: data, urlParameters: urlParameters)
        case .userCheckMail(let mail):
            urlParameters = urlParameters + ["mail": mail]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .oauthToken:
           
            bodyParameters = bodyParameters + ["grant_type": "client_credentials"]
            
            let data = requestBodyEncrypted(body: bodyParameters)
            
            return .requestCompositeData(bodyData: data, urlParameters: urlParameters)
            
        case .registerVerifyCode(let type, let mail):
            
            urlParameters = urlParameters + ["type": type, "mail": mail]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .lockList(let lockName, let groupId, let authType, let page, let size):
            
            if lockName != nil {
                urlParameters = urlParameters + ["lockName": lockName!]
            }
            
            if groupId != nil {
                urlParameters = urlParameters + ["groupId": groupId!]
            }
            if authType != nil {
                urlParameters = urlParameters + ["authType": authType!]
            }
            
            urlParameters = urlParameters + ["page": page, "size": size, "userId": (ConfigModel.default.user.value?.id)!, "corpId": (ConfigModel.default.user.value?.corpId)!]
            
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .lockKey(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        case .updateLock(let battery, let firmwareVersion, let hardwareVersion, let id, let latitude, let longitude, let lockName, let morseCode, let morseStatus, let syncType):
            
            if battery != nil {
                bodyParameters = bodyParameters + ["battery": battery!]
            }
            if firmwareVersion != nil {
                bodyParameters = bodyParameters + ["firmwareVersion": firmwareVersion!]
            }
            if hardwareVersion != nil {
                bodyParameters = bodyParameters + ["hardwareVersion": hardwareVersion!]
            }
            if latitude != nil {
                bodyParameters = bodyParameters + ["latitude": latitude!]
            }
            if longitude != nil {
                bodyParameters = bodyParameters + ["longitude": longitude!]
            }
            if lockName != nil {
                bodyParameters = bodyParameters + ["lockName": lockName!]
            }
            if morseCode != nil {
                bodyParameters = bodyParameters + ["morseCode": morseCode!]
            }
            if morseStatus != nil {
                bodyParameters = bodyParameters + ["morseStatus": morseStatus!]
            }
        
            bodyParameters = bodyParameters + ["id": id, "syncType": syncType]
            
            let data = requestBodyEncrypted(body: bodyParameters)
            
            return .requestCompositeData(bodyData: data, urlParameters: urlParameters)
            
        case .historyList(let lockId, let userName, let beginTime, let endTime, let queryType, let size, let page):
            
           
            if userName != nil {
                urlParameters = urlParameters + ["userName": userName!]
            }
            if beginTime != nil {
                urlParameters = urlParameters + ["beginTime": beginTime!]
            }
            if endTime != nil {
                urlParameters = urlParameters + ["endTime": endTime!]
            }
            
            if lockId != nil {
                 urlParameters = urlParameters + ["lockId": lockId!]
            }
            
            urlParameters = urlParameters + ["queryType": queryType, "page": page, "size": size]
            
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .closeTimeHistory(let corpId, let lockId, let operateTime):
            bodyParameters = bodyParameters + ["corpId": corpId, "lockId": lockId, "operateTime": operateTime]
            let data = requestBodyEncrypted(body: bodyParameters)
            return .requestCompositeData(bodyData: data, urlParameters: urlParameters)
            
        case .openTimeHistory(let corpId, let latitude, let longitude, let lockId, let morseOperateTimes, let unlockFingerprints, let unlockType, let userId):
            
            if latitude != nil {
                bodyParameters = bodyParameters + ["latitude": latitude!]
            }
            if longitude != nil {
                bodyParameters = bodyParameters + ["longitude": longitude!]
            }
            if morseOperateTimes != nil {
                bodyParameters = bodyParameters + ["morseOperateTimes": morseOperateTimes!]
            }
            if unlockFingerprints != nil {
                bodyParameters = bodyParameters + ["unlockFingerprints": unlockFingerprints!]
            }
            if longitude != nil {
                bodyParameters = bodyParameters + ["longitude": longitude!]
            }
            
            bodyParameters = bodyParameters + ["corpId": corpId, "lockId": lockId, "userId": userId, "unlockType": unlockType]
            
            let data = requestBodyEncrypted(body: bodyParameters)
            return .requestCompositeData(bodyData: data, urlParameters: urlParameters)
            
        case .downloadFingerprint(let lockId):
            urlParameters = urlParameters + ["lockId": lockId]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .updateFingerprintSycnState(let lockId, let fingerprintIds, let lockFingerprintIndex):
            urlParameters = urlParameters + ["lockId": lockId, "fingerprintIds": fingerprintIds, "lockFingerprintIndex": lockFingerprintIndex]
            
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .userUpdate(let fcmDeviceToken, let firstName, let groupIds, let id, let lastName, let permissionIds, let phone, let photoUrl, let sex):
            
            if fcmDeviceToken != nil {
                bodyParameters = bodyParameters + ["fcmDeviceToken": fcmDeviceToken!]
            }
            if firstName != nil {
                bodyParameters = bodyParameters + ["firstName": firstName!]
            }
            if groupIds != nil {
                bodyParameters = bodyParameters + ["groupIds": groupIds!]
            }
            if lastName != nil {
                bodyParameters = bodyParameters + ["lastName": lastName!]
            }
            if permissionIds != nil {
                bodyParameters = bodyParameters + ["permissionIds": permissionIds!]
            }
            if phone != nil {
                bodyParameters = bodyParameters + ["phone": phone!]
            }
            if photoUrl != nil {
                bodyParameters = bodyParameters + ["photoUrl": photoUrl!]
            }
            if sex != nil {
                bodyParameters = bodyParameters + ["sex": sex!]
            }
            
            bodyParameters = bodyParameters + ["id": id]
            let data = requestBodyEncrypted(body: bodyParameters)
            return .requestCompositeData(bodyData: data, urlParameters: urlParameters)
            
        case .changePassword(let newPassword, let oldPassword):
            bodyParameters = bodyParameters + ["newPassword": newPassword, "oldPassword": oldPassword, "id": (ConfigModel.default.user.value?.id)!]
            let data = requestBodyEncrypted(body: bodyParameters)
            return .requestCompositeData(bodyData: data, urlParameters: urlParameters)
        
        case .feedBack(let content, let title, let corpId, let source, let platform):
            bodyParameters = bodyParameters + ["userId": (ConfigModel.default.user.value?.id)!, "content": content, "title": title, "corpId": corpId, "source": source, "platform": platform]
            let data = requestBodyEncrypted(body: bodyParameters)
            return .requestCompositeData(bodyData: data, urlParameters: urlParameters)
        
        case .checkinviteCodes(let inviteCode):
            urlParameters = urlParameters + ["inviteCode": inviteCode]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        
        case .checkVerifyCode(let mail, let verifyCode):
            urlParameters = urlParameters + ["mail": mail, "verifyCode": verifyCode]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        
        case .checkFirmwares(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        }
        
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    
}
