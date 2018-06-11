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
let APIVersion2 = "v2"
let APIHost = "http://34.220.89.68:8888"//测试
//let APIHost = "https://api.tapplock.com"


let provider = MoyaProvider<ApiService>(plugins: [NetworkLoggerPlugin(verbose: true)])

//定义各种网络接口
enum ApiService {

    case Login(mail: String, password: String)
    case Locks(mail: String, myOwner: Bool)
    case AddLock(key1: String, key2: String, mac: String, serialNo: String, userUUID: String, lockName: String, imageURL: String?)
    case FingerPrints(lockId: Int, page: Int, size: Int)
    case CheckFingerPrint(fingerOwner: String, fingerType: Int, handType: Int, lockId: Int)
    case FingerOwners(uuid: String, page: Int, size: Int)
    case EditeLock(lockId: Int, LockName: String?, imageUrl: String?, morseCode: String?)
    case AddFingerOwner(uuid: String, ownerName: String)
    case AddFingerPrint(ownerUUID: String, fingerType: Int, fingerprintIndex: String, handType: Int, lockID: Int, mail: String)
    case DeleteFingerprint(id: Int)
    case DeletLock(id: Int)
    case ShareAccess(mail: String, page: Int, size: Int)
    case DeleteUserId(id: Int)
    case ShareUsers(mail: String, page: Int, size: Int)
    case AddShareUser(mail: String, name: String, uuid: String)
    case EditShareUser(name: String, id: Int)
    case AddShareAccess(mail: String, lockID: Int, oneAccess: Bool, permanent: Bool, startDate: Date?, endDate: Date?, uuid: String)
    case EditeShareAccess(mail: String, lockID: Int, oneAccess: Bool, permanent: Bool, startDate: Date?, endDate: Date?, shareID: Int)
    case BluetoothHistory(uuid: String, page: Int, size: Int)
    case FingerprintHistory(uuid: String, page: Int, size: Int)
    case AddHistoryFingerprint(fingerprintIndex: Array<Any>, mac: String, uuid: String)
    case V1addHistoryFingerprint(fingerprintIndex: Array<Any>, mac: String, uuid: String)
    case AddHistoryBluetooth(lockId: Int, shareUuid: String, userUuid: String)
    case EditUserConfiguration(mai: String,
                               deviceToken: String?,
                               firstName: String?,
                               lastName: String?,
                               imageURL: String?,
                               push: Bool?,
                               showBattery: Bool?)
    case ForgetPasswordVerifyCode(mail: String)
    case RegisterVerifyCode(mail: String)
    case Register(firstName: String, lastName: String, mail: String, imageURL: String, password: String, vCode: String)
    case CheckUser(mail: String)
    case ForgetPassword(mail: String, newPassword: String, verifyCode: String)
    case ChangePassword(mail: String, newPassword: String, oldPassword: String)
    case Feedback(title: String, content: String)
    case UpdateLocktion(latitude: String, longitude: String, uuid: String)
    case SupportVersion
    case UpdateFirmware(hardVersion: String)
    
}

//设置各种网络接口
extension ApiService: TargetType {
    var headers: [String: String]? {
        switch self {
        case .Login(_, _), .CheckUser(_), .ForgetPassword(_, _, _):
            return ["Content-type": "application/json", "lang": ConfigModel.default.language.code]
        case .ForgetPasswordVerifyCode(_),
             .Register(_, _, _, _, _, _),
             .RegisterVerifyCode(_):
            return ["Content-type": "application/json", "lang": ConfigModel.default.language.code]
        default:
            return ["Content-type": "application/json", "Authorization": (ConfigModel.default.user.value?.basicToken ?? ""), "lang": ConfigModel.default.language.code]
        }
    }

    var baseURL: URL {
        switch self {
        case .AddHistoryFingerprint(_, _, _):
            return URL(string: APIHost + "/api/\(APIVersion2)/")!
        default:
            return URL(string: APIHost + "/api/\(APIVersion)/")!
        }
        
    }

    var path: String {
        switch self {
        case .Login(_, _):
            return "users/actions/login"
        case .Locks(let mail, _):
            return "locks/\(mail)"
        case .FingerPrints(let lockId, _, _):
            return "fingers/\(lockId)"
        case .EditeLock(_, _, _, _):
            return "locks"
        case .FingerOwners(let uuid, _, _):
            return "finger_owners/" + uuid
        case .AddFingerOwner(_, _):
            return "finger_owners"
        case .AddFingerPrint(_, _, _, _, _, _):
            return "fingers"
        case .DeleteFingerprint(let id):
            return "fingers/\(id)"
        case .AddLock(_, _, _, _, _, _, _):
            return "locks"
        case .DeletLock(let id):
            return "locks/\(id)"
        case .ShareAccess(let mail, _, _):
            return "shares/\(mail)"
        case .DeleteUserId(let id):
            return "shares/\(id)"
        case .ShareUsers(let mail, _, _):
            return "shareable_users/\(mail)"
        case .AddShareUser(_, _, _):
            return "shareable_users"
        case .EditShareUser(_, _):
            return "shareable_users"
        case .AddShareAccess(_, _, _, _, _, _, _):
            return "shares"
        case .EditeShareAccess(_, _, _, _, _, _, _):
            return "shares"
        case .BluetoothHistory(let uuid, _, _):
            return "unlock_records/bluetooth/" + uuid
        case .FingerprintHistory(let uuid, _, _):
            return "unlock_records/fingerprints/" + uuid
        case .AddHistoryFingerprint(_, _, _),.V1addHistoryFingerprint(_, _, _):
            return "unlock_records/fingerprint/actions/sync"
        
        case .AddHistoryBluetooth(_, _, _):
            return "unlock_records/bluetooth"
        case .EditUserConfiguration(_, _, _, _, _, _, _):
            return "users"
        case .ForgetPasswordVerifyCode(let mail),
             .RegisterVerifyCode(let mail):
            return "verifycode/" + mail
        case .Register(_, _, _, _, _, _):
            return "users"
        case .CheckUser(let mail):
            return "users/actions/check_user/" + mail
        case .ForgetPassword(_, _, _):
            return "users/actions/forget_pwd"
        case .ChangePassword(_, _, _):
            return "users/actions/change_pwd"
        case .Feedback(_, _):
            return "feedbacks"
        case .UpdateLocktion(_, _, _):
            return "users/actions/updateLocation"
        case .SupportVersion:
            return "support_version/2"
        case .CheckFingerPrint(_, _, _, _):
            return "fingers/actions/check"
        case .UpdateFirmware(_):
            return "firmware_update"
        }
    }

    var method: Moya.Method {
        switch self {
        case .Login(_, _),
             .AddFingerPrint(_, _, _, _, _, _),
             .AddLock(_, _, _, _, _, _, _),
             .AddShareUser(_, _, _),
             .AddShareAccess(_, _, _, _, _, _, _),
             .AddHistoryFingerprint(_, _, _),
             .V1addHistoryFingerprint(_, _, _),
             .AddHistoryBluetooth(_, _, _),
             .Register(_, _, _, _, _, _),
             .Feedback(_, _),
             .CheckFingerPrint(_, _, _, _),
             .AddFingerOwner(_, _):
            return .post
        case .Locks(_, _),
             .FingerPrints(_, _, _),
             .ShareAccess(_, _, _),
             .ShareUsers(_, _, _),
             .BluetoothHistory(_, _, _),
             .FingerprintHistory(_, _, _),
             .ForgetPasswordVerifyCode(_),
             .RegisterVerifyCode(_),
             .CheckUser(_),
             .SupportVersion,
             .UpdateFirmware(_),
             .FingerOwners(_, _, _):
            return .get
        case .EditeLock(_, _, _, _),
             .EditUserConfiguration(_, _, _, _, _, _, _),
             .ForgetPassword(_, _, _),
             .ChangePassword(_, _, _),
             .EditShareUser(_, _):
            return .patch
        case .DeleteFingerprint(_),
             .DeleteUserId(_),
             .DeletLock(_):
            return .delete
        case .EditeShareAccess(_, _, _, _, _, _, _),
             .UpdateLocktion(_, _, _):
            return .put

        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    var task: Task {//parameters
        var parameters: [String: Any] = ["device": "1", "version": "v2.0"]

        switch self {
        case .CheckUser(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
        case .Register(let firstName, let lastName, let mail, let imageURL, let password, let vCode):
            return .requestParameters(parameters: ["firstName": firstName, "lastName": lastName, "imageUrl": imageURL, "mail": mail, "password": password, "verifyCode": vCode] + parameters, encoding: JSONEncoding.default)

        case .Login(let mail, let password):
            return .requestParameters(parameters: ["mail": mail, "password": password] + parameters, encoding: JSONEncoding.default)
        case .Locks(_, let myOwner):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["page": 1, "size": 100, "myOwner": myOwner] + parameters)
        case .FingerPrints(_, let page, let size):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["page": page, "size": size] + parameters)
        case .EditeLock(let lockId, let LockName, let imageUrl, let morseCode):

            if LockName != nil {
                parameters = parameters + ["lockName":LockName!]
            }
            if imageUrl != nil {
                parameters = parameters + ["imageUrl":imageUrl!]
            }
            if morseCode != nil {
                parameters = parameters + ["morseCode":morseCode!]
            }
            parameters = ["lockId":lockId] + parameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .FingerOwners(let uuid, let page, let size):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["page": page, "size": size, "userUuid": uuid] + parameters)
        case .AddFingerOwner(let uuid, let ownerName):
            return .requestParameters(parameters: ["userUuid": uuid, "ownerName": ownerName] + parameters, encoding: JSONEncoding.default)
        case .AddFingerPrint(let ownerUUID, let fingerType, let fingerprintIndex, let handType, let lockID, let mail):
            return .requestParameters(parameters: ["fingerOwner": ownerUUID,
                                                   "fingerType": fingerType,
                                                   "fingerprintIndex": fingerprintIndex,
                                                   "handType": handType,
                                                   "lockId": lockID,
                                                   "mail": mail]
                    + parameters, encoding: JSONEncoding.default)

        case .DeleteFingerprint(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
        case .AddLock(let key1, let key2, let mac, let serialNo, let userUUID, let lockName, let imageURL):
            return .requestParameters(parameters: ["imageUrl": imageURL ?? "",
                                                   "key1": key1,
                                                   "key2": key2,
                                                   "lockName": lockName,
                                                   "mac": mac.macText,
                                                   "serialNo": serialNo,
                                                   "userUuid": userUUID,
            ]
                    + parameters, encoding: JSONEncoding.default)
        case .DeletLock(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
        case .DeleteUserId(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: parameters)
        
        case .ShareAccess(let mail, let page, let size):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["page": page, "size": size, "mail": mail] + parameters)
        case .ShareUsers(let mail, let page, let size):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["page": page, "size": size, "mail": mail] + parameters)
        case .AddShareUser(let mail, let name, let uuid):
            return .requestParameters(parameters: ["mail": mail, "nickName": name, "userUuid": uuid] + parameters, encoding: JSONEncoding.default)

        case .EditShareUser(let name, let id):
            return .requestParameters(parameters: ["shareableUserId": id, "nickName": name] + parameters, encoding: JSONEncoding.default)

        case .AddShareAccess(let mail, let lockID, let oneAccess, let permanent, let startDate, let endDate, let uuid):

            parameters = parameters + [
            "oneAccess":(oneAccess ? 1:0),
            "permanent":(permanent ? 1:0),
            "toUserMail":mail,
            "userUuid":uuid,
            "lockId":lockID]
            if !permanent {
                parameters = parameters + ["startDate":(startDate != nil ? startDate!.timeStemp:""),
                "endDate":(endDate != nil ? endDate!.timeStemp:"")]
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .BluetoothHistory(_, let page, let size):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["page": page, "size": size] + parameters)
        case .FingerprintHistory(_, let page, let size):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["page": page, "size": size] + parameters)
        case .EditeShareAccess(let mail, let lockID, let oneAccess, let permanent, let startDate, let endDate, let shareID):
            parameters = parameters + [
            "oneAccess":(oneAccess ? 1:0),
            "permanent":(permanent ? 1:0),
            "shareId":shareID,
            "toUserMail":mail,
            "lockId":lockID]

            if !permanent {
                parameters = parameters + ["startDate":(startDate != nil ? startDate!.timeStemp:""),
                "endDate":(endDate != nil ? endDate!.timeStemp:"")]
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .AddHistoryFingerprint(let fingerprintIndex, let mac, let uuid):
            return .requestParameters(parameters: ["unlockDatas": fingerprintIndex, "mac": mac.macText, "userUuid": uuid] + parameters, encoding: JSONEncoding.default)
        case .V1addHistoryFingerprint(let fingerprintIndex, let mac, let uuid):
            return .requestParameters(parameters: ["fingerprintIndex": fingerprintIndex, "mac": mac.macText, "userUuid": uuid] + parameters, encoding: JSONEncoding.default)
        case .AddHistoryBluetooth(let lockId, let shareUuid, let userUuid):
            if shareUuid != "-1" {
                parameters = parameters + ["shareUuid":shareUuid]
            }
            return .requestParameters(parameters: ["lockId": lockId, "userUuid": userUuid] + parameters, encoding: JSONEncoding.default)
        case .EditUserConfiguration(let mail, let deviceToken, let firstName, let lastName, let imageURL, let push, let showBattery):
            if (deviceToken != nil) {
                parameters = parameters + ["fcmDeviceToken":deviceToken!]
            }
            if firstName != nil {
                parameters = parameters + ["firstName":firstName!]
            }
            if lastName != nil {
                parameters = parameters + ["lastName":lastName!]
            }
            if imageURL != nil {
                parameters = parameters + ["imageUrl":imageURL!]
            }
            if push != nil {
                parameters = parameters + ["push":(push! ? 1:0)]
            }
            if showBattery != nil {
                parameters = parameters + ["showBattery":(showBattery! ? 1:0)]
            }
            parameters = parameters + ["mail":mail]

            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .ForgetPasswordVerifyCode(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["type": 2] + parameters)
        case .RegisterVerifyCode(_):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["type": 1] + parameters)
        case .ForgetPassword(let mail, let newPassword, let verifyCode):
            return .requestParameters(parameters: ["mail": mail, "newPassword": newPassword, "verifyCode": verifyCode] + parameters, encoding: JSONEncoding.default)
        case .ChangePassword(let mail, let newPassword, let oldPassword):
            return .requestParameters(parameters: ["mail": mail, "newPassword": newPassword, "oldPassword": oldPassword] + parameters, encoding: JSONEncoding.default)
        case .Feedback(let title, let content):
            return .requestParameters(parameters: ["title": title, "content": content] + parameters, encoding: JSONEncoding.default)
        case .UpdateLocktion(let latitude, let longitude, let uuid):
            return .requestParameters(parameters: ["latitude": latitude, "longitude": longitude, "userUuid": uuid] + parameters, encoding: JSONEncoding.default)
        case .SupportVersion:
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["deviceType": "2"] + parameters)
        case .UpdateFirmware(let hardversion):
            return .requestCompositeData(bodyData: Data.init(), urlParameters: ["hardwareVersion": hardversion] + parameters)
        case .CheckFingerPrint(let fingerOwner, let fingerType, let handType, let lockId):
            return .requestParameters(parameters: ["fingerOwner": fingerOwner, "fingerType": fingerType, "handType": handType, "lockId": lockId] + parameters, encoding: JSONEncoding.default)
        }
    }
}

