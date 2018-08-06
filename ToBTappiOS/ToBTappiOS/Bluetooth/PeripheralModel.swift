//
//  PeripheralModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/31.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa
import NSObject_Rx

//物理蓝牙模型
class PeripheralModel: NSObject {
    
    public var rx_mac: Variable<String?> = Variable(nil)
    public var rx_status: Variable<CBPeripheralState> = Variable(.disconnected)
    public var rx_battery: Variable<Int?> = Variable(nil)
    public var rx_hardware: Variable<String?> = Variable(nil)
    public var rx_firmware: Variable<String?> = Variable(nil)
    public var rx_response: Variable<BluetoothResponse> = Variable(.NoResponse)
    public var rx_historyTotals: Variable<Int> = Variable(0)
    
    var key1: String!
    var serialNo: String!
    var secretKey: Data!
    var id: Int!
    var morseStatus: Int!
    var lockStatus: Int!
    
    var peripheral: CBPeripheral!
    //可读Characteristic
    var readCharacteristic: CBCharacteristic?
    //可写Characteristic
    var writeCharacteristic: CBCharacteristic?
    
    var bleUpdate: BLEUpdate?
    
    //初始化方法
    init(_ peripheral: CBPeripheral) {
        super.init()
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        self.bleUpdate = BLEUpdate(self)
        
        peripheral.rx.observe(CBPeripheralState.self, "state").map({$0!}).distinctUntilChanged().bind(to: rx_status).disposed(by: rx.disposeBag)
        
        let response = rx_response.asObservable().share(replay: 1)
        
        response.filter({ $0.battery != nil }).map { $0.battery! }.bind(to: rx_battery).disposed(by: rx.disposeBag)
        
        response.filter({ $0.firemwareVersion != nil }).map { $0.firemwareVersion! }.bind(to: rx_firmware).disposed(by: rx.disposeBag)
        
        response.filter({ $0.hardVersion != nil }).map { $0.hardVersion! }.bind(to: rx_hardware).disposed(by: rx.disposeBag)
        
        response.filter({ $0.historyTotals != nil}).map { $0.historyTotals! }.bind(to: rx_historyTotals).disposed(by: rx.disposeBag)
        
        self.rx_mac.value = peripheral.mac
        
    }
    
    deinit {
        plog("peripheral销毁了")
    }
}


extension PeripheralModel {
    
    func setResponse(data: Data) {
        
        guard let response = BluetoothResponse.init(data) else {
            let none = data.hexadecimal()
            plog("未被处理的数据\(none)")
            return
        }
        
        self.rx_response.value = response
        
        switch response {
            
        case .GetFiremwareVersion:
            
            sendGetRandom()
            
        case .GetRandomData:
            guard let num = response.randomNumer else { return }
            
            randomKeyServeEncrpted(numer: num)
            
        case .VerifyRandom:
            
            if response.success == true {
                sendPairingCommand()
            } else {
                plog("认证失败")
            }
            
        case .PairingRegular:
            
            sendBatteryCommand()
            
        case .Battery:
            
            sendTimeCommd()
            
        case .GMTTime:
            sendGetHistory()
            
        case .History:
            
            plog("xxxxxx")
            
            // 数据历史获取完成
            
            switch self.lockStatus {
            case -1:
                self.bleUpdate?.deleteLock()
            case 0:
                self.bleUpdate?.showTotals()
                self.bleUpdate?.loadAPI()
        
            case 1:
                if self.morseStatus == 0 {
                    self.bleUpdate?.showTotals()
                    self.bleUpdate?.downloadMorseCode()
                }
            default:
                break
            }
            
            
            
        default:
            break
        }
    }
    

}


extension PeripheralModel: CBPeripheralDelegate {
    
    //接受数据
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let hex = characteristic.value!.hexadecimal()
        let cmd = hex[0...3]
        if cmd == "aa55" {
            setResponse(data: characteristic.value!)
        } else {
            responseDecrypted(data: characteristic.value!)
        }
    }
    // 发现外设
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        onDiscoverServices(peripheral)
    }
    
    // 发现特征
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        onDiscoverCharacteristics(peripheral, service: service)
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


