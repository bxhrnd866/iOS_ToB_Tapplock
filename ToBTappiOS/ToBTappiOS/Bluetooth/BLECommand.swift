//
//  BluetoothCommand.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/2.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import Foundation

let CDM_PREFIX = "55AA"
let CDM_PassKey = "AE9566C7"
let CMD_GetDeviceMac = CDM_PREFIX + "9A010000"
let CMD_PairingFirstTime = CDM_PREFIX + "81010400"
let CMD_PairingRegular = CDM_PREFIX + "B4010800"
let CMD_Booting = CDM_PREFIX + "92010C00"
let CMD_Battery = CDM_PREFIX + "81030000"
let CMD_Unlock = CDM_PREFIX + "81020000"
let CMD_DeleteFingerprint = CDM_PREFIX + "45020200"
let CMD_FactoryReset = CDM_PREFIX + "E3010000"
let CMD_MorseCode = CDM_PREFIX + "EB020200"
let CMD_History = CDM_PREFIX + "9B020000"
let CMD_DFU = CDM_PREFIX + "27010000"
let CMD_GetFirmWareVersion = CDM_PREFIX + "45010000"
let CMD_SendTime = CDM_PREFIX + "10020600"
let CMD_SetDeviceName = CDM_PREFIX + "8901"
let CMD_SetDeviceNameII = CDM_PREFIX + "8a01"
let CMD_GetRandomData = CDM_PREFIX + "01030000"
let CMD_VerifyRandom = CDM_PREFIX + "02030C00"
let CMD_SendFingerprintStart = CDM_PREFIX + "89020000"
let CMD_SendFingerprintData = CDM_PREFIX + "e0"
let CMD_SendFingerprintEnd = CDM_PREFIX + "8a020000"
let CMD_SendClearMorseCode = CDM_PREFIX + "ec020000"


//蓝牙通信指令,参考蓝牙通信文档
enum BluetoothCommand {
    case GetDeviceMac
    case PairingFirstTime
    case PairingRegular(key: String, serialNumber: String)
    case Booting(key1: String, key2: String, serialNumber: String)
    case Battery
    case Unlock
    case DeleteFingerprint(index: String)
    case FactoryReset
    case History
    case MorseCode(code: String)
    case DFUModel
    case GetFirmWareVersion
    case SendTime(time: String)
    case SetDeviceName(name: String)
    case SetDeviceNameII(lastname: String)
    case GetRandomData
    case VerifyRandom(key: String)
    case SendFingerprintStart
    case SendFingerprintData(data: String)
    case SendFingerprintEnd
    case SendClearMoreseCode
    
    var commandString: String {
        switch self {
        case .GetDeviceMac:
            return CMD_GetDeviceMac
        case .PairingFirstTime:
            print("PairingFirstTime:" + CMD_PairingFirstTime + CDM_PassKey)
            return CMD_PairingFirstTime + CDM_PassKey
        case .PairingRegular(let key, let serialNumber):
            print("PairingRegular:" + CMD_PairingRegular + key + serialNumber)
            return CMD_PairingRegular + key + serialNumber
        case .Booting(let key1, let key2, let serialNumber):
            print("Booting:" + CMD_Booting + key1 + key2 + serialNumber)
            return CMD_Booting + key1 + key2 + serialNumber
        case .Unlock:
            return CMD_Unlock
        case .Battery:
            return CMD_Battery
            
        case .DeleteFingerprint(let index):
            return CMD_DeleteFingerprint + index
        case .FactoryReset:
            plog("FactoryReset:" + CMD_FactoryReset)
            return CMD_FactoryReset
        case .MorseCode(let code):
            return CMD_MorseCode + code
        case .History:
             plog("NewHistory:" + CMD_History)
            return CMD_History
        case .DFUModel:
            return CMD_DFU
        case .GetFirmWareVersion:
            return CMD_GetFirmWareVersion
        case .SendTime(let time):
            plog("time: \(CMD_SendTime + time)")
            return CMD_SendTime + time
        case .SetDeviceName(let name):
            plog("setDeviceName: \(CMD_SetDeviceName + name)")
            return CMD_SetDeviceName + name
        case .SetDeviceNameII(let name):
            return CMD_SetDeviceNameII + name
        case .GetRandomData:
            return CMD_GetRandomData
        case .VerifyRandom(let key):
            return CMD_VerifyRandom + key
        case .SendFingerprintStart:
            return CMD_SendFingerprintStart
        case .SendFingerprintData(let data):
            return CMD_SendFingerprintData + data
        case .SendFingerprintEnd:
            return CMD_SendFingerprintEnd
        case .SendClearMoreseCode:
            return CMD_SendClearMorseCode
        }
    }

    var command: Data {
        switch self {
        default:
            var data = commandString.hexadecimal()
            let chechSum = data!.checksum()
            let chechSumData = Data.init(bytes: [chechSum.lowByte(), chechSum.highByte()])
            data?.append(contentsOf: chechSumData)
            return data!
        }
    }
}


