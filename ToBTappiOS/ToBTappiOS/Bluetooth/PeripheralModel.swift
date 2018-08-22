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
    
    var fingerprintOpen = [[String: Any]]()
    var morseOpen = [Int]()
    var closeHistory = [Int]()
    var morseNum = 0
    
    
    //初始化方法
    init(_ peripheral: CBPeripheral) {
        super.init()
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        self.bleUpdate = BLEUpdate(self)
        
        let response = rx_response.asObservable().share(replay: 1)
        
        response.filter({ $0.battery != nil }).map { $0.battery! }.bind(to: rx_battery).disposed(by: rx.disposeBag)
        
        response.filter({ $0.firemwareVersion != nil }).map { $0.firemwareVersion! }.bind(to: rx_firmware).disposed(by: rx.disposeBag)
        
        response.filter({ $0.hardVersion != nil }).map { $0.hardVersion! }.bind(to: rx_hardware).disposed(by: rx.disposeBag)
        
      
        
        
        peripheral.rx.observe(CBPeripheralState.self, "state").map({$0!})
            .distinctUntilChanged()
            .asObservable()
            .subscribe(onNext: { [weak self] state in
                self?.rx_status.value = state
                
                if state == .disconnected {
                    if SyncView.instance.rx_numers.value > 0 {
                        SyncView.instance.rx_numers.value -= 1
                    }
                }
                
            
        }).disposed(by: rx.disposeBag)
        
        
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
//            plog("未被处理的数据\(none)")
            return
        }
       
        self.rx_response.value = response
        
        switch response {
        
        case .GetDeviceMac:
            
            plog(response.mac)
            
        case .GetFiremwareVersion:
            
//            sendGetRandom()
            
    
            randomKeyServeEncrpted(numer: "01020304")
            
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
            if response.success {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.sendBatteryCommand()
                }
                
            } else {
                plog("配对失败")
            }
            
        case .Battery:
            
            sendTimeCommd()
            
        case .GMTTime:
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.sendGetHistory()
            }
    
        case .HistoryNumers:
            
            if let tuple = response.historyNums {
                if tuple.0 == 0 && tuple.1 == 0 {
                    self.bleUpdate?.updateLockState()
                } else {
                    morseNum = tuple.1
                }
            }
        
        case .OpenHistory:
            
            guard let open = response.openTime , let finerHistory = response.FingerprintHistory else { return }
            if finerHistory == true {
                let dict = ["lockFingerprintIndex": open.0, "operateTime": open.1] as [String : Any]
                self.fingerprintOpen.append(dict)
            } else {
                self.morseOpen.append(open.1)
            }
        case .OpenEnd:
            
            if morseNum == 0 {
               self.bleUpdate?.updateHistoryTime(close: closeHistory, finger: fingerprintOpen, morese: morseOpen)
            }
        case .CloseHistory:
            guard let close = response.closeTime else { return }
            self.closeHistory.append(close)
            
        case .CloseEnd:
            self.bleUpdate?.updateHistoryTime(close: closeHistory, finger: fingerprintOpen, morese: morseOpen)
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


