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
let RCM_EnrollFingerprint = RCM_PREFIX + "9202"
let RCM_DeleteFingerprint = RCM_PREFIX + "4502"
let RCM_FactoryReset = RCM_PREFIX + "E301"
let RCM_MorseCode = RCM_PREFIX + "EB02"
let RCM_History = RCM_PREFIX + "D0"
let RCM_T2_AllHistory = RCM_PREFIX + "9B02"
let RCM_GetFirmwareVersion = RCM_PREFIX + "4501"
let RCM_GMTTime = RCM_PREFIX + "1002"
let RCM_SetDeviceName = RCM_PREFIX + "8901"
let RCM_GetRandomData = RCM_PREFIX + "0103"
let RCM_VerifyRandom = RCM_PREFIX + "0203"
let RCM_FingerprintEnd = RCM_PREFIX + "8a02"
let RCM_Unlock = RCM_PREFIX + "8102"

//蓝牙通信响应,参考蓝牙通信文档
enum BluetoothResponse {
    case NoResponse
    case PairingFirstTime(value: String)
    case Booting(value: String)
    case PairingRegular(value: String)
    case GetDeviceMac(value: String)
    case Battery(value: String)
    case EnrollFingerprint(value: String)
    case DeleteFingerprint(value: String)
    case FactoryReset(value: String)
    case MorseCode(value: String)
    case History(value: String)
    case GetFiremwareVersion(value: String)
    case GMTTime(value: String)
    case HistoryPacket(value: String)
    case SetDeviceName(value: String)
    case T2AllHistory(value: String)
    case GetRandomData(value: String)
    case VerifyRandom(value: String)
    case FingerprintEnd(value: String)
    case Unlock(value: String)
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
             .EnrollFingerprint(let value),
             .FactoryReset(let value),
             .MorseCode(let value),
             .DeleteFingerprint(let value),
             .History(let value),
             .GetFiremwareVersion(let value),
             .HistoryPacket(let value),
             .GMTTime(let value),
             .SetDeviceName(let value),
             .GetRandomData(let value),
             .VerifyRandom(let value),
             .FingerprintEnd(let value),
             .Unlock(let value),
             .T2AllHistory(let value):
            return value
        }
    }

    init?(_ data: Data) {
        let response = data.hexadecimal()
        let index = response.index(response.startIndex, offsetBy: 7)
        let cmd: String = String(response[...index])
        if (cmd.uppercased().contains(RCM_History)) {
            self = .History(value: response)
            return
        }
        switch cmd.uppercased() {
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
        case RCM_EnrollFingerprint:
            print("RCM_EbrollFinger:" + response)
            self = .EnrollFingerprint(value: response)
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
        case RCM_T2_AllHistory:
            plog("二代锁指纹\(response)")
            self = .T2AllHistory(value: response)
        case RCM_GetRandomData:
            self = .GetRandomData(value: response)
        case RCM_VerifyRandom:
            plog("验证密文\(response)")
            self = .VerifyRandom(value: response)
        case RCM_FingerprintEnd:
            self = .FingerprintEnd(value: response)
        case RCM_Unlock:
            self = .Unlock(value: response)
        default:
            return nil
        }
    }
    
    var firemwareVersion: String?  {
        switch self {
        case .GetFiremwareVersion:
            
            if self.value == nil {
                return nil
            }
            
            if self.rawValue.length < 21 {
                plog("太短")
                return nil
            }
            
            let fm = self.rawValue[18...21]
            let val = self.rawValue[14...17]
            if val != "0001" && val != "0002"{
                return fm.exchangeSequence()
            }
            return fm
        default:
            return nil
        }
    }
    
    var hardVersion: String?  {
        switch self {
        case .GetFiremwareVersion:
            if self.value == nil {
                plog("固件号为空")
                return nil
            }
            if (self.value?.length)! < 4 {
                plog("固件号为空")
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
    
    var errorMessage: String? {
        switch self {
        case .EnrollFingerprint(_):
            if self.success {
                return nil
            } else {
                switch self.value {
                case "0100":
                    return R.string.localizable.errorMessage_EnrollTemplateExisted()
                case "02100":
                    return R.string.localizable.errorMessage_EnrollNoSpace()
                case "0300"?:
                    return R.string.localizable.errorMessage_EnrollMismatch()
                default:
                    return R.string.localizable.errorMessage_Enroll()
                }
            }
        default:
            return nil
        }
    }
    
    var historyTotals: Int? {  //总历史条数
        switch self {
        case .T2AllHistory(_):
            guard let val = self.value else {
                return nil
            }
            let xm = val[0...1]
            return xm.hexToInt
            
        default:
            return nil
        }
    }
    
    var historyNumber: Int? { // 第几条
        switch self {
        case .History(_):
            let val = self.rawValue[6...7]
            return val.hexToInt
        default:
            return nil
        }
    }
    // 数据包长度
    var dataLength: Int? {
        switch self {
        default:do {
            let str = self.rawValue[8...9]
            let length = str.hexToInt
            return length!
            }
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
    

    var value: String? {
        switch self {
        case .History(_):
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




