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

//let APIHost = "http://192.168.7.213:8781"

let APIHost = "https://entapi.tapplock.com"

let APILock = "/lock/api/v1/"
let APIUser = "/user/api/v1/"

let provider = MoyaProvider<APIServer>(plugins: [NetworkLoggerPlugin(verbose: true)])

enum APIServer {
    
    case oauthToken(grant_type: String?, refresh_token: String?, access_token: String?) // 初次获取token  password client_credentials
    case userRegister(corpId: Int, fcmDeviceToken: String?, inviteCode: String, firstName: String, lastName: String, mail: String, password: String, phone: String, photoUrl: String?, sex: Int)  //0-男 1-女
    case userLog(mail: String, password: String)
    case userUpdate(fcmDeviceToken: String?, firstName: String?, groupIds: [String]?, lastName: String?, permissionIds: [Int]?, phone: String?, photoUrl: String?, sex: Int?) // 更新用户信息
    case registerVerifyCode(mail: String, type: Int)  // 0-注册 1-忘记密码
    case checkVerifyCode(mail: String, verifyCode: String) // 校验验证码
    case checkinviteCodes(inviteCode: String) //校验邀请码
    case chagePassword(newPassword: String, oldPassword: String) //修改密码
    case forgetPassword(mail: String, newPassword: String, verifyCode: String)
    case lockList(userId: Int?, lockName: String?, groupIds: String?, authType: Int?, page: Int, size: Int)  //授权类型0-蓝牙 1-指纹  锁列表
    case allGroupslist
    case updateLock(battery: String?, firmwareVersion: String?, hardwareVersion: String?, lockId: Int, latitude: String?, longitude: String?, location: String?, lockName: String?, morseCode: String?, morseStatus: Int?, syncTypes: [Int]) //更新锁信息  更新类型0-地理位置 1-固件 2-其他
    case updateLockHistory(accessTypes: [Int],closeOperateTimes: Array<Any>?, latitude: String?, longitude: String?, location: String?, lockId: Int, morseOperateTimes: Array<Any>?, operateLocalDate: String, unlockFingerprints: Array<Any>?, userId: Int?)  //解锁类型0-蓝牙解锁 1-指纹解锁 2-摩斯码解锁 3-关锁
    case historyList(userId: Int?, lockId: Int?, targetName: String?, beginTime: Int?, endTime: Int?, accessType: Int, size: Int, page: Int, groupIds: String?)  // 查询类型(逗号分隔）0-fingerprint 1-bluetooth,2-close 3-auth bluetooth 4-auth fingerprint 5-cancel bluetooth 6-cancel fingerprint 7-location 8-firmware 9-other
    case checkFirmwares(hardwareVersion: String)
    case feedBack(content: String, title: String) // 反馈
    case userFingerPrint // 查询用户下的指纹
    case downloadFingerprint(lockId: Int)  // 下载指纹
    case updateFingerprintSycnState(relSyncStatusUpdateBOList: Array<Any>) // 更新指纹同步状态  0-下载指纹到锁成功 1-删除指纹成功
    case macforAnylock(mac: String, randNum: String)
    case deleteLocks(id: Int)
    case downloadMorsecode(id: Int)

}
//            let value = "tapplock-b2b-client:tapplock123!@#".toBase64()
extension APIServer: TargetType{
    
    var headers: [String : String]? {
    
        switch self {
        case .oauthToken(_, _, _):
            return ["Content-type": "application/json", "Authorization": "Basic dGFwcGxvY2stYjJiLWNsaWVudDp0YXBwbG9jazEyMyFAIw==", "clientType": "1"]
        case .userLog(_, _),
             .forgetPassword(_, _, _),
             .userRegister(_, _, _, _, _, _, _, _, _, _),
             .checkinviteCodes(_),
             .checkVerifyCode(_, _),
             .chagePassword(_, _):
    
            return ["Content-type": "application/json", "clientType": "1"]
        case .registerVerifyCode(_, _):
           
            return ["Content-type": "application/json", "clientType": "1", "lang": ConfigModel.default.language.code]
        default:
            
            let basicToken = UserDefaults.standard.object(forKey: key_basicToken) as? String
            return ["Content-type": "application/json", "clientType": "1", "Authorization": "Bearer " + (basicToken ?? "aaaaaa")]
        }
    }
    
    var baseURL: URL {
        switch self {
        case .oauthToken:
            return URL(string: APIHost)!
        case .userLog(_, _),
             .forgetPassword(_, _, _),
             .userRegister(_, _, _, _, _, _, _, _, _, _),
             .checkinviteCodes(_),
             .userUpdate(_, _, _, _, _, _, _, _),
             .registerVerifyCode(_, _),
             .checkVerifyCode(_, _),
             .allGroupslist,
             .feedBack(_, _),
             .updateFingerprintSycnState(_):
            return URL(string: APIHost + APIUser)!
        default:
            return URL(string: APIHost + APILock)!
        }
    }
    
    
    var path: String {
        switch self {
        case .userRegister(_, _, _, _, _, _, _, _, _, _):
            return "users/register"
        case .userLog(_, _):
            return "users/login"
        case .userUpdate(_, _, _, _, _, _, _, _):
            return "users"
        case .registerVerifyCode(_, _):
            return "users/get_verify_code"
        case .lockList(_,_, _, _, _, _):
            return "locks/for_staff"
        case .updateLock(_, _, _, _, _, _, _, _, _, _, _):
            return "locks"
        case .historyList(_, _, _, _, _, _, _, _, _):
            return "lock_histories/access_history"
        case .updateLockHistory(_, _, _, _, _, _, _, _, _, _):
            return "lock_histories"
        case .oauthToken(_,_, _):
            return "uaa/oauth/token"
        case .downloadFingerprint(_):
            return "fingerprints/to_be_downloaded"
        case .updateFingerprintSycnState(_):
            return "auth_rels/update_rel"
        case .forgetPassword(_, _, _):
            return "users/forgot_password"
        case .feedBack(_, _):
            return "feedback"
        case .checkinviteCodes(_):
            return "invite_codes/check_invite"
        case .checkVerifyCode(_, _):
            return "users/check_verify_code"
        case .checkFirmwares(let hardwareVersion):
            return "firmwares/\(ConfigModel.default.language.code)/\(hardwareVersion)"
        case .userFingerPrint:
            return "fingerprints/user_fingerprint/\(ConfigModel.default.user.value?.id ?? 1234567890)"
        case .allGroupslist:
            return "groups/list"
        case .chagePassword(_, _):
            return "users/change_password"
        case .macforAnylock(_, _):
            return "locks/any_lock"
        case .deleteLocks(let id):
            return "locks/callback/\(id)"
        case .downloadMorsecode(_):
            return "locks/morse_code"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .lockList(_,_, _, _, _, _),
             .historyList(_, _, _, _, _, _, _, _, _),
             .registerVerifyCode(_, _),
             .downloadFingerprint(_),
             .checkinviteCodes(_),
             .checkFirmwares(_),
             .userFingerPrint,
             .allGroupslist,
             .macforAnylock(_, _),
             .checkVerifyCode(_, _),
             .downloadMorsecode(_):
            return .get
        case .updateLock(_, _, _, _, _, _, _, _, _, _, _),
             .updateFingerprintSycnState(_),
             .userUpdate(_, _, _, _, _, _, _, _),
             .chagePassword(_, _):
            return .put
        case .oauthToken(let a,_, _):
            if a == nil {
                return .delete
            } else {
                return .post
            }
            
        case .userRegister(_, _, _, _, _, _, _, _, _, _),
             .userLog(_, _),
             .forgetPassword(_, _, _),
             .updateLockHistory(_, _, _, _, _, _, _, _, _, _),
             .feedBack(_, _):
            return .post
        case .deleteLocks(_):
            return .delete
            
        }
    }
    
    var task: Task {

        var urlParameters = [String: Any]()
        
        var bodyParameters = [String: Any]()
        
        switch self {
            
        case .userRegister(let corpId, let fcmDeviceToken, let inviteCode, let firstName, let lastName, let mail, let password, let phone, let photoUrl, let sex):
            
            if fcmDeviceToken != nil {
                bodyParameters = bodyParameters + ["fcmDeviceToken": fcmDeviceToken!]
            }
            
            if photoUrl != nil {
                bodyParameters = bodyParameters + ["photoUrl": photoUrl!]
            }
          
            bodyParameters = bodyParameters + ["corpId": corpId,
                                               "phone": phone,
                                               "inviteCode": inviteCode,
                                               "firstName": firstName,
                                               "lastName": lastName,
                                               "mail": mail,
                                               "password": password.sha256(),
                                               "sex": sex,
                                               "langType": ConfigModel.default.language.code,
                                               "platform": 1]
            
            

            return .requestParameters(parameters: bodyParameters, encoding: JSONEncoding.default)
            
        case .userLog(let mail, let password):
            
            bodyParameters = bodyParameters + ["mail": mail, "password": password.sha256(), "clientType": 1]
           
            return .requestParameters(parameters: bodyParameters, encoding: JSONEncoding.default)
            
        case .oauthToken(let grant_type, let refresh_token, let access_token):
            
            
            if refresh_token != nil {
                urlParameters = urlParameters + ["refresh_token": refresh_token!]
            }
            if grant_type != nil {
                urlParameters = urlParameters + ["grant_type": grant_type!]
            }
            if access_token != nil {
                urlParameters = urlParameters + ["access_token": access_token!]
            }
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .registerVerifyCode(let mail, let type):
            
            urlParameters = urlParameters + ["type": type, "mail": mail]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .lockList(let userId, let lockName, let groupIds, let authType, let page, let size):
            
            if userId != nil {
                urlParameters = urlParameters + ["userId": userId!]
            }
            if lockName != nil {
                urlParameters = urlParameters + ["lockName": lockName!]
            }
            
            if groupIds != nil {
                urlParameters = urlParameters + ["groupIds": groupIds!]
            }
            if authType != nil {
                urlParameters = urlParameters + ["authType": authType!]
            }
            
            urlParameters = urlParameters + ["page": page, "size": size, "corpId": (ConfigModel.default.user.value?.corpId) ?? 11]
            
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        
        case .userFingerPrint:
            
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .allGroupslist:
            
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters + ["corpId": ConfigModel.default.user.value?.corpId ?? 1234567])
            
        case .updateLock(let battery, let firmwareVersion, let hardwareVersion, let lockId, let latitude, let longitude, let location, let lockName, let morseCode, let morseStatus, let syncTypes):
           
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
            
            if location != nil {
                bodyParameters = bodyParameters + ["location": location!]
            }
        
            bodyParameters = bodyParameters + ["lockId": lockId, "syncTypes": syncTypes]
            
            return .requestParameters(parameters: bodyParameters, encoding: JSONEncoding.default)
            
        case .historyList(let userId, let lockId, let targetName, let beginTime, let endTime, let accessType, let size, let page, let groupIds):
            
           
            if userId != nil {
                urlParameters = urlParameters + ["userId": userId!]
            }
            if targetName != nil {
                urlParameters = urlParameters + ["targetName": targetName!]
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
            
            if groupIds != nil {
                 urlParameters = urlParameters + ["groupIds": groupIds!]
            }
            urlParameters = urlParameters + ["accessType": accessType, "page": page, "size": size, "corpId": ConfigModel.default.user.value?.corpId ?? 1234567]
            
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .updateLockHistory(let accessType, let closeOperateTimes, let latitude, let longitude, let location, let lockId, let morseOperateTimes, let operateLocalDate, let unlockFingerprints, let userId):
            
            if userId != nil {
                bodyParameters = bodyParameters + ["userId": userId!]
            }
          
            if closeOperateTimes != nil {
                bodyParameters = bodyParameters + ["closeOperateTimes": closeOperateTimes!]
            }
            if latitude != nil {
                bodyParameters = bodyParameters + ["latitude": latitude!]
            }
            if longitude != nil {
                bodyParameters = bodyParameters + ["longitude": longitude!]
            }
            if location != nil {
                bodyParameters = bodyParameters + ["location": location!]
            }
            
            if morseOperateTimes != nil {
                bodyParameters = bodyParameters + ["morseOperateTimes": morseOperateTimes!]
            }
            
            if unlockFingerprints != nil {
                bodyParameters = bodyParameters + ["unlockFingerprints": unlockFingerprints!]
            }
           
            bodyParameters = bodyParameters + ["corpId": (ConfigModel.default.user.value?.corpId) ?? 11, "lockId": lockId, "accessTypes": accessType, "operateLocalDate": operateLocalDate]
            
            return .requestParameters(parameters: bodyParameters, encoding: JSONEncoding.default)
            
        case .downloadFingerprint(let lockId):
            urlParameters = urlParameters + ["lockId": lockId]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
            
        case .updateFingerprintSycnState(let relSyncStatusUpdateBOList):

            let data = try? JSONSerialization.data(withJSONObject: relSyncStatusUpdateBOList, options: [])
            
            return .requestCompositeData(bodyData: data!, urlParameters: urlParameters)
            
        case .userUpdate(let fcmDeviceToken, let firstName, let groupIds, let lastName, let permissionIds, let phone, let photoUrl, let sex):
            
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
            
            bodyParameters = bodyParameters + ["userId": (ConfigModel.default.user.value?.id)!]
    
            return .requestParameters(parameters: bodyParameters, encoding: JSONEncoding.default)
            
        case .forgetPassword(let mail, let newPassword, let verifyCode):
            bodyParameters = bodyParameters + ["newPassword": newPassword.sha256(), "verifyCode": verifyCode, "mail": mail]
            return .requestParameters(parameters: bodyParameters, encoding: JSONEncoding.default)
            
        case .chagePassword(let newPassword,  let oldPassword):
            
            bodyParameters = bodyParameters + ["newPassword": newPassword.sha256(), "oldPassword": oldPassword.sha256(), "userId": (ConfigModel.default.user.value?.id)!]
            return .requestParameters(parameters: bodyParameters, encoding: JSONEncoding.default)
        
        case .feedBack(let content, let title):
            bodyParameters = bodyParameters + ["userId": (ConfigModel.default.user.value?.id)!, "content": content, "title": title, "corpId": (ConfigModel.default.user.value?.corpId)!, "source": 1, "platform": 0]

            return .requestParameters(parameters: bodyParameters, encoding: JSONEncoding.default)
        
        case .checkinviteCodes(let inviteCode):
            urlParameters = urlParameters + ["inviteCode": inviteCode]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        
        case .checkVerifyCode(let mail, let verifyCode):
            urlParameters = urlParameters + ["mail": mail, "verifyCode": verifyCode]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        
        case .checkFirmwares(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        
        case .macforAnylock(let mac, let randNum):
            urlParameters = urlParameters + ["mac": mac, "randNum": randNum]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        case .deleteLocks(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        case .downloadMorsecode(let id):
            urlParameters = urlParameters + ["lockId": id]
            return .requestCompositeData(bodyData: Data.init(), urlParameters: urlParameters)
        }
        
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    
}
