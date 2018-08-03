//
//  PeripheralCommander.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/31.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import CoreBluetooth
import CryptoSwift


extension PeripheralModel {
    
    func sendGetRandom() {
        plog("获取随机数")
        writeEncryptedData(data: BluetoothCommand.GetRandomData.command)
    }
    
    func sendVerifyRandom(numer: String) {
        plog("验证令牌")
        peripheral.writeValue(BluetoothCommand.VerifyRandom(key: numer).command, for: writeCharacteristic!, type: .withResponse)
    }
    
    public func sendGetDeviceMacCommand() {
        plog("发送获取MAC地址")
        writeEncryptedData(data: BluetoothCommand.GetDeviceMac.command)
    }
    
    func sendEnterIntoDFU() -> Void {
        writeEncryptedData(data: BluetoothCommand.DFUModel.command)
    }
    
    func sendGetFiremwareCommand() -> Void {
        plog("发送获取固件版本")
        
        peripheral.writeValue(BluetoothCommand.GetFirmWareVersion.command, for: writeCharacteristic!, type: .withResponse)
        
    }
    
    public func sendBatteryCommand() {
        plog("发送电量")
        writeEncryptedData(data: BluetoothCommand.Battery.command)
    }
    
    public func sendRestCommand() {
        plog("发重置指令")
        writeEncryptedData(data: BluetoothCommand.FactoryReset.command)
    }
    
    public func sendPairingCommand() {
        guard let key = key1 else {
            return
        }
        guard let seria = serialNo else {
            return
        }
        plog("发送配对连接")
        writeEncryptedData(data: BluetoothCommand.PairingRegular(key: key, serialNumber: seria).command)
    }
    
    public func sendMorseCodeCommand(code: String) {
        plog("发送获MorseCode")
        writeEncryptedData(data: BluetoothCommand.MorseCode(code: code).command)
    }
    
    public func sendUnlockCommand() {
        writeEncryptedData(data: BluetoothCommand.Unlock.command)
    }
    
    public func sendEnrollCommand() {
        writeEncryptedData(data: BluetoothCommand.EnrollFingerprint.command)
    }
    
    public func sendDeleteFingerprintCommand(index: String!) {
        writeEncryptedData(data: BluetoothCommand.DeleteFingerprint(index: index).command)
    }
    
    public func sendTimeCommd(){
        let times = GMTCoverToHex()
        writeEncryptedData(data: BluetoothCommand.SendTime(time: times).command)
    }
    
    public func sendGetHistory() {
        writeEncryptedData(data: BluetoothCommand.NewHistory.command)
    }
    
    public func sendStartFingerprint() {
        writeEncryptedData(data: BluetoothCommand.SendFingerprintStart.command)
    }
    
    public func sendEndFingerprint() {
        writeEncryptedData(data: BluetoothCommand.SendFingerprintEnd.command)
    }
    
    public func sendFingerPrintData(data: String) {
        
        writeEncryptedData(data: BluetoothCommand.SendFingerprintData(data: data).command)
    }
    
    
    
}


