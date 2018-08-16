//
//  ResponseModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/1.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit

let RCM_PREFIX = "AA55"
let RCM_GetDeviceMac = RCM_PREFIX + "9A01"
let RCM_PairingFirstTime = RCM_PREFIX + "8101"
let RCM_Booting = RCM_PREFIX + "9201"
let RCM_PairingRegular = RCM_PREFIX + "B401"
let RCM_Battery = RCM_PREFIX + "8103"
let RCM_DeleteFingerprint = RCM_PREFIX + "4502"
let RCM_FactoryReset = RCM_PREFIX + "E301"
let RCM_MorseCode = RCM_PREFIX + "EB02"
let RCM_GetFirmwareVersion = RCM_PREFIX + "4501"
let RCM_GMTTime = RCM_PREFIX + "1002"
let RCM_SetDeviceName = RCM_PREFIX + "8901"
let RCM_GetRandomData = RCM_PREFIX + "0103"
let RCM_VerifyRandom = RCM_PREFIX + "0203"
let RCM_FingerprintEnd = RCM_PREFIX + "8A02"
let RCM_Unlock = RCM_PREFIX + "8102"
let RCM_AllHistory = RCM_PREFIX + "9B02"
let RCM_OpenTime = RCM_PREFIX + "A0"
let RCM_OpenTimeEnd = RCM_PREFIX + "AFFF"
let RCM_CloseTime = RCM_PREFIX + "B0"
let RCM_CloseTimeEnd = RCM_PREFIX + "BFFF"
let RCM_ClearMorseCode = RCM_PREFIX + "ec02"


//蓝牙通信响应,参考蓝牙通信文档
enum BluetoothResponse {
    case NoResponse
    case PairingFirstTime(value: String)
    case Booting(value: String)
    case PairingRegular(value: String)
    case GetDeviceMac(value: String)
    case Battery(value: String)
    case DeleteFingerprint(value: String)
    case FactoryReset(value: String)
    case MorseCode(value: String)
    case GetFiremwareVersion(value: String)
    case GMTTime(value: String)
    case SetDeviceName(value: String)
    case GetRandomData(value: String)
    case VerifyRandom(value: String)
    case FingerprintEnd(value: String)
    case Unlock(value: String)
    case HistoryNumers(value: String)
    case OpenHistory(value: String)
    case OpenEnd(value: String)
    case CloseHistory(value: String)
    case CloseEnd(value: String)
    case ClearMorseCode(value: String)
    
    
    typealias RawValue = String
    var rawValue: RawValue {
        switch self {
        case .NoResponse:
            return ""
        case .PairingFirstTime(let value),
             .GetDeviceMac(let value),
             .Booting(let value),
             .PairingRegular(let value),
             .Battery(let value),
             .FactoryReset(let value),
             .MorseCode(let value),
             .DeleteFingerprint(let value),
             .GetFiremwareVersion(let value),
             .GMTTime(let value),
             .SetDeviceName(let value),
             .GetRandomData(let value),
             .VerifyRandom(let value),
             .FingerprintEnd(let value),
             .Unlock(let value),
             .HistoryNumers(let value),
             .OpenHistory(let value),
             .OpenEnd(let value),
             .CloseHistory(let value),
             .ClearMorseCode(let value),
             .CloseEnd(let value):
            return value
        }
    }

    init?(_ data: Data) {
        let response = data.hexadecimal()
        let cmd = response[0...7].uppercased()
        
        if cmd.contains(RCM_OpenTime) {
            plog("开开-->\(response)")
            self = .OpenHistory(value: response)
            
            return
        }
        
        if cmd.contains(RCM_CloseTime) {
            plog("关关-->\(response)")
            self = .CloseHistory(value: response)
            return
        }
        
        switch cmd {
        case RCM_PairingFirstTime:
            print("RCM_PairingFirstTime:" + response)
            self = .PairingFirstTime(value: response)
        case RCM_GetDeviceMac:
            print("RCM_GetDeviceMac:" + response)
            self = .GetDeviceMac(value: response)
        case RCM_Booting:
            print("RCM_Booting:" + response)
            self = .Booting(value: response)
        case RCM_PairingRegular:
            print("RCM_PairingRegular:" + response)
            self = .PairingRegular(value: response)
        case RCM_Battery:
            print("RCM_Battery:" + response)
            self = .Battery(value: response)
        case RCM_DeleteFingerprint:
            print("RCM_DeleteFingerprint:" + response)
            self = .DeleteFingerprint(value: response)
        case RCM_FactoryReset:
            print("RCM_FactoryReset:" + response)
            self = .FactoryReset(value: response)
        case RCM_MorseCode:
            print("RCM_MorseCode:" + response)
            self = .MorseCode(value: response)
        case RCM_GetFirmwareVersion:
            print("RCM_GetFirmwareVersion:" + response)
           
            self = .GetFiremwareVersion(value: response)
        case RCM_GMTTime:
            print("已经sendGMT时间")
            self = .GMTTime(value: response)
        case RCM_SetDeviceName:
            print("设置名字返回: \(response)")
            self = .SetDeviceName(value: response)
        case RCM_GetRandomData:
            self = .GetRandomData(value: response)
        case RCM_VerifyRandom:
            plog("验证密文\(response)")
            self = .VerifyRandom(value: response)
        case RCM_FingerprintEnd:
            self = .FingerprintEnd(value: response)
        case RCM_Unlock:
            self = .Unlock(value: response)
        case RCM_AllHistory:
            plog("锁指纹总计数目\(response)")
            self = .HistoryNumers(value: response)
        case RCM_OpenTimeEnd:
            plog("开结束\(response)")
            self = .OpenEnd(value: response)
        case RCM_CloseTimeEnd:
            plog("关结束\(response)")
            self = .CloseEnd(value: response)
        default:
            return nil
        }
    }
    
    var firemwareVersion: String?  {
        switch self {
        case .GetFiremwareVersion:
            
            if self.value == nil || self.value?.length != 8 {
                return nil
            }
           
            let a = self.value![4...7]
            return a
        default:
            return nil
        }
    }
    
    var hardVersion: String?  {
        switch self {
        case .GetFiremwareVersion:
            if self.value == nil || self.value?.length != 8 {
                return nil
            }
            
            let val = TapplockType(rawValue: (self.value?[0...3])!)
            return val?.deviceType
        default:
            return nil
        }
    }
    
    var mac: String? {
        switch self {
        case .GetDeviceMac:
            
            plog(self.value)
            return self.value
        default:
            return nil
        }
    }
    
    var serialNumber: String? {
        switch self {
        case .PairingFirstTime:
            return self.value?.substring(0, length: 8)
        default:
            return nil
        }
    }
    
    var isNewLock: Bool? {
        switch self {
        case .PairingFirstTime:
            return self.success
        default:
            return nil
        }
    }
    var battery: Int? {
        switch self {
        case .Battery:
            return (self.success ? self.value?.hexToInt : nil)
        default:
            return nil
        }
    }

    var success: Bool {
        switch self {
        default:do {
           
            let startIndex = self.rawValue.index((self.rawValue.startIndex), offsetBy: 12)
            let endIndex = self.rawValue.index((self.rawValue.startIndex), offsetBy: 13)
            return String(self.rawValue[startIndex...endIndex]) == "01"
        }
        }
    }

    var fingerprintID: String? {
        switch self {
        case .FingerprintEnd(_):
            return (self.success ? self.value : nil)
        default:
            return nil
        }
    }
    

    
    // 随机数
    var randomNumer: String? {
        switch self {
        case .GetRandomData(_):
            return self.value
        default:
            return nil
        }
    }
    
    
    var historyNums: (Int, Int)? {
        switch self {
        case .HistoryNumers(_):
            
            if self.value == nil || (self.value?.length)! < 8 {
                return nil
            }
            
            let a = self.value![0...3].exchangeSequence().hexToInt
            let b = self.value![4...7].exchangeSequence().hexToInt
            return (a!, b!)
            
        default:
            return nil
        }
    }
    
    
    
    
    var FingerprintHistory: Bool? {
        switch self {
        case .OpenHistory(_):
            
            if self.value == nil {
                return nil
            }
            let type = self.value![0...3]
            
            if type == "0160" {
                return false
            } else {
                return true
            }
            
        default:
            return nil
        }
    }
    
    
    var openTime: (String, Int)? {
        switch self {
        case .OpenHistory(_):
            if self.value == nil {
                return nil
            }
            let index = self.value![0...3]
            let type = self.value![4...(self.value?.count)! - 1]
            let time = hexCovertoTamp(time: type)
            if time == nil {
                return nil
            } else {
               return (index, time!)
            }
            
        default:
            return nil
        }
    }
    
    var closeTime: Int? {
        switch self {
        case .CloseHistory(_):
            if self.value == nil {
                return nil
            }
            
            let time = hexCovertoTamp(time: self.value!)
            return time
        default:
            return nil
        }
    }
    
    
    
    

    var value: String? {
        switch self {
        case .OpenHistory, .CloseHistory:
            let startIndex = self.rawValue.index((self.rawValue.startIndex), offsetBy: 12)
            let endIndex = self.rawValue.index(self.rawValue.startIndex, offsetBy: (self.rawValue.count) - 5)
            if startIndex >= endIndex {
                return nil
            } else {
                return String(self.rawValue[startIndex...endIndex])
            }
        default:
            let startIndex = self.rawValue.index((self.rawValue.startIndex), offsetBy: 14)
            let endIndex = self.rawValue.index(self.rawValue.startIndex, offsetBy: (self.rawValue.count) - 5)
            if startIndex >= endIndex {
                return nil
            } else {
                return String(self.rawValue[startIndex...endIndex])
            }
        }
    }

    

}




