//
//  BLEPeripheral.swift
//  ToBTapplcok
//
//  Created by TapplockiOS on 2018/4/11.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import CoreBluetooth
import RxCocoa
import RxSwift
import NSObject_Rx

class BLEPeripheral: NSObject {
    
    var name: String? {
        return self.peripheral.name
    }
    
    var fingerprintID: String?
    var key1: String?
    var key2: String?
    var serialNumber: String?
    
    
    var rx_mac: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var rx_staus: BehaviorRelay<CBPeripheralState> = BehaviorRelay(value: .disconnected)
    var rx_battery: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    var rx_hardware:  BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var rx_firmware: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var rx_response: BehaviorRelay<BluetoothResponse> = BehaviorRelay(value: BluetoothResponse.NoResponse)
    var rx_historyTotals: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    var historys = [Any]()
    
    
    // 工具属性
    //可读Characteristic
    var readCharacteristic: CBCharacteristic?
    //可写Characteristic
    var writeCharacteristic: CBCharacteristic?
    
    var peripheral: CBPeripheral
    
    // 第一次连接
    var isFirstPairing: Bool = false
    
    init(_ peripheral: CBPeripheral) {
        
        self.peripheral = peripheral
        super.init()
        self.peripheral.delegate = self
        
       _ = peripheral.rx.observe(CBPeripheralState.self, "state").map({$0!}).distinctUntilChanged().bind(to: rx_staus).disposed(by: rx.disposeBag)
        
        let response = rx_response.asObservable().share(replay: 1)
        
        response.filter({ $0.mac != nil }).map { $0.mac! }.bind(to: rx_mac).disposed(by: rx.disposeBag)
        
        response.filter({ $0.battery != nil }).map { $0.battery! }.bind(to: rx_battery).disposed(by: rx.disposeBag)
        
        response.filter({ $0.firemwareVersion != nil }).map { $0.firemwareVersion! }.bind(to: rx_firmware).disposed(by: rx.disposeBag)
        
        response.filter({ $0.hardVersion != nil }).map { $0.hardVersion! }.bind(to: rx_hardware).disposed(by: rx.disposeBag)
        
        response.filter({ $0.historyTotals != nil}).map { $0.historyTotals! }.bind(to: rx_historyTotals).disposed(by: rx.disposeBag)
        
    }
    
    deinit {
        plog("Peripheral销毁了")
    }
}

extension BLEPeripheral: CBPeripheralDelegate {
    
    //接受数据
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let response = BluetoothResponse.init(characteristic.value!) else {
            let none = characteristic.value!.hexadecimal()
            print("未被处理的数据: \(none)")
            return
        }
        self.rx_response.accept(response)

        plog(response.rawValue)

        
        switch response {
        case .GetDeviceMac:
            TapplockManager.default.loackConnectModel(self)
            
        case .PairingRegular:
            
            sendGetFiremwareCommand()
            
        case .GetFiremwareVersion:
            
            sendBatteryCommand()
            
        case .Battery:
           
            guard let hv = self.rx_hardware.value else {
                return
            }
            
            switch hv {
            case TL1:
                sendGetHistory()
            case TL2:
                
                sendTimeCommd()
            default:
                plog("版本为空")
            }
            
        case .GMTTime:
            sendGetHistory()
            
        case .History:
            
            lockCollectHistory(response: response)
            
        case .T2AllHistory:
    
            plog(response.historyTotals ?? 2001)
         
        case .Booting:
            plog("booting成功")
        
        case .PairingFirstTime:
            
            if response.success {
                plog("first成功")
                sendGetFiremwareCommand()
            } else {
                plog("first失败")
            }
        
        default:
            plog("老铁,吃了吗")
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
}
