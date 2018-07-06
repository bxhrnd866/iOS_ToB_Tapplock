//
//  PeripheralService.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/6/21.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import Foundation
import CoreBluetooth
extension PeripheralModel {
    
    func sendGetRandom() {
        plog("获取随机数")
        writeEncryptedData(data: BluetoothCommand.GetRandomData.command)
    }
    
    func sendVerifyRandom(numer: String) {
        plog("验证令牌")
        
        let x = BluetoothCommand.VerifyRandom(key: numer).command.hexadecimal()
        plog(x)
        
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
    
    public func sendPairingFirstTimeCommand() {
        plog("发送第一次连接")
        writeEncryptedData(data: BluetoothCommand.PairingFirstTime.command)
    }
    
    public func sendRestCommand() {
        plog("发重置指令")
        writeEncryptedData(data: BluetoothCommand.FactoryReset.command)
    }
    
    public func sendPairingCommand() {
        guard let key = key1 else {
            return
        }
        guard let seria = serialNumber else {
            return
        }
        plog("发送配对连接")
        writeEncryptedData(data: BluetoothCommand.PairingRegular(key: key, serialNumber: seria).command)
    }
    
    public func sendMorseCodeCommand(code: String) {
        plog("发送获MorseCode")
        writeEncryptedData(data: BluetoothCommand.MorseCode(code: code).command)
    }
    
    public func sendBootCommand() {
        guard let key = key1 else {
            return
        }
        guard let seria = serialNumber else {
            return
        }
        guard let key2 = key2 else {
            return
        }
        plog("发送获Botting")
        
        writeEncryptedData(data: BluetoothCommand.Booting(key1: key, key2: key2, serialNumber: seria).command)
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
        plog("发送获取历史记录")
        guard let tp = self.rx_hardware.value else {
            return
        }
        if tp == aKind {
            writeEncryptedData(data: BluetoothCommand.History.command)
        }
        if tp == bKind {
            writeEncryptedData(data: BluetoothCommand.NewHistory.command)
        }
    }
    
    func sendSetDeviceName(name: String) {
        plog("发送设置设备名称")
        let new = name.data(using: .utf8)
        let hex = new?.hexadecimal()
        
        guard let count = hex?.count else { return }
        if count <= 24 {
            
            let length =  "0" + String(count).decimalConver()! + "00" + hex!
            writeEncryptedData(data: BluetoothCommand.SetDeviceName(name: length).command)
            writeEncryptedData(data: BluetoothCommand.SetDeviceNameII(lastname: "0000").command)
        } else {
            
            let a = hex![0...23]
            let b = hex![24...count - 1]
            let numer = count/2 - 12
            
            let lengthA =  "0c00" + a
            let lengthB = "0" + String(numer).decimalConver()! + "00" + b
            
            writeEncryptedData(data: BluetoothCommand.SetDeviceName(name: lengthA).command)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.08) {
                self.writeEncryptedData(data: BluetoothCommand.SetDeviceNameII(lastname: lengthB).command)
            }
        }
    }
    
    // MARK: 搜索服务
    public func onDiscoverServices(_ peripheral: CBPeripheral) {
        for service in peripheral.services! {
            if service.uuid.uuidString == UUID_SERVICE {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    // MARK: 搜索特征
    public func onDiscoverCharacteristics(_ peripheral: CBPeripheral, service: CBService) {
        
        for characteristic in service.characteristics! {
            switch characteristic.uuid.uuidString {
            case UUID_Characteristic_SEND:
                writeCharacteristic = characteristic
                sendGetFiremwareCommand()
//                sendGetDeviceMacCommand()
                break
            case UUID_Characteristic_RECIEVE:
                readCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
                break
            default:
                break
            }
        }
    }
}


