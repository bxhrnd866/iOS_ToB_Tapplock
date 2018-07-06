//
//  BluetoothPeripheralModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/11/28.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import CoreBluetooth
import RxSwift
import RxCocoa
import NSObject_Rx

//物理蓝牙模型
class PeripheralModel: NSObject {
   
    var name: String! {
        return self.peripheral.name
    }
    
    public var serialNumber: String?
    public var key1: String?
    public var key2: String?
   
    
    public var rx_mac: Variable<String?> = Variable(nil)
    public var rx_status: Variable<CBPeripheralState> = Variable(.disconnected)
    public var rx_battery: Variable<Int?> = Variable(nil)
    public var rx_hardware: Variable<String?> = Variable(nil)
    public var rx_firmware: Variable<String?> = Variable(nil)
    public var rx_response: Variable<BluetoothResponse> = Variable(.NoResponse)
    public var rx_historyTotals: Variable<Int> = Variable(0)
    
    
    
    
    // toolsValue
    var historys = [Any]()
    var secretSource = [Any]()
    var timer: Timer?
    var dataLength: Int = 0
    // 加密key
    public var secretKey: Data?
    // 是否第一次连接
    var isFirstPairing = false
    var historyString: String? = nil
    
    
    
    //物理蓝牙,直接发送指令的对象
    var peripheral: CBPeripheral!
    //可读Characteristic
    var readCharacteristic: CBCharacteristic?
    //可写Characteristic
    var writeCharacteristic: CBCharacteristic?

  
    
 
    //初始化方法
    init(_ peripheral: CBPeripheral) {
        super.init()
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        _ = peripheral.rx.observe(CBPeripheralState.self, "state").map({$0!}).distinctUntilChanged().bind(to: rx_status).disposed(by: rx.disposeBag)
        
        let response = rx_response.asObservable().share(replay: 1)
        
        response.filter({ $0.mac != nil }).map { $0.mac! }.bind(to: rx_mac).disposed(by: rx.disposeBag)
        
        response.filter({ $0.battery != nil }).map { $0.battery! }.bind(to: rx_battery).disposed(by: rx.disposeBag)
        
        response.filter({ $0.firemwareVersion != nil }).map { $0.firemwareVersion! }.bind(to: rx_firmware).disposed(by: rx.disposeBag)
        
        response.filter({ $0.hardVersion != nil }).map { $0.hardVersion! }.bind(to: rx_hardware).disposed(by: rx.disposeBag)
        
        response.filter({ $0.historyTotals != nil}).map { $0.historyTotals! }.bind(to: rx_historyTotals).disposed(by: rx.disposeBag)
        
        
    }
   

    deinit {
        plog("peripheral销毁了")
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
    
    func setResponse(data: Data) {
        
        guard let response = BluetoothResponse.init(data) else {
            let none = data.hexadecimal()
            plog("未被处理的数据\(none)")
            return
        }
        
        self.rx_response.value = response
        
        switch response {
            
        case .GetFiremwareVersion:
            
            if self.rx_hardware.value == nil {
                self.sendGetDeviceMacCommand()
                return
            }
            
            if self.rx_mac.value != nil {
                sendBatteryCommand()
                return
            }
            
            sendGetRandom()
            
        case .GetRandomData:
            guard let num = response.randomNumer else { return }
           
            randomKeyServeEncrpted(numer: num)
        case .VerifyRandom:
            if response.success == true {
                sendGetDeviceMacCommand()
            }
            
        case .GetDeviceMac:
           
            TapplockManager.default.lockConnectModel(self)
            
        case .PairingRegular:
            if secretKey == nil {
                sendGetFiremwareCommand()
            } else {
                sendBatteryCommand()
            }
            
        case .Battery:
            
            guard let hv = self.rx_hardware.value else {
                return
            }
            
            switch hv {
            case aKind:
                sendGetHistory()
            case bKind:
                sendTimeCommd()
            default: break }
            
        case .GMTTime:
            sendGetHistory()
            
        case .History:
           
            lockCollectHistory(response: response)
            
        case .T2AllHistory:
            
            plog(response.historyTotals ?? 2001)
            
        default:
            break
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



