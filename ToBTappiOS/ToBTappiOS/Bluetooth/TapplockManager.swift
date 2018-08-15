//
//  TapplockManager.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/11/27.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreBluetooth
import CoreLocation
import CFAlertViewController

let UUID_SERVICE = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
let DFU_SERVICE = "00001530-1212-EFDE-1523-785FEABCD123"
let UUID_Characteristic_SEND = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
let UUID_Characteristic_RECIEVE = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

final class TapplockManager: NSObject {
   
    var manager: CBCentralManager!
    
    var rx_peripherals = Variable(Set<PeripheralModel>())

    var isConnectPeripheral = Set<CBPeripheral>()

    var editingLock: TapplockModel? = nil
    
    var rx_dfuLock: Variable<CBPeripheral?> = Variable(nil)
    
    var rx_deleteLock: Variable<String?> = Variable(nil)
    
    var rx_viewmodel: TapplockViewModel?
    
    
    static let `default` = TapplockManager()
    
    private override init() {
        super.init()
        manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
    }
    
    public func reInitManager() -> Void {
        manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
    }
    
    //Reset方法,用户退出时调用
    public func reset() {
        stop()
        rx_peripherals.value = []
        editingLock = nil
        
    }

    public func scan() {
        if ConfigModel.default.user.value != nil  {
           manager.scanForPeripherals(withServices: [CBUUID.init(string: UUID_SERVICE),CBUUID.init(string: DFU_SERVICE)], options: nil)
        }
        
    }
    
    public func stop() {
        manager.stopScan()
        for lock in rx_peripherals.value {
            if let peripheral = lock.peripheral {
                manager.cancelPeripheralConnection(peripheral)
            }
        }
    }
    
    // 扫描到锁时添加
    public func addTapplock(_ peripheral: CBPeripheral) {
        if !(self.rx_peripherals.value.reduce(false, { $0 || $1 == peripheral })) {
            let peripheralModel = PeripheralModel.init(peripheral)
            self.rx_peripherals.value.insert(peripheralModel)
            
        }
    }
  

}

// MARK: 蓝牙相关
extension TapplockManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            manager.scanForPeripherals(withServices: [CBUUID.init(string: UUID_SERVICE),CBUUID.init(string: DFU_SERVICE)], options: nil)
        default:
            break
        }
    }
    
    //发现设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        plog(peripheral.name)
        plog(advertisementData)
//        if let data = advertisementData["kCBAdvDataManufacturerData"] {
//            let hex = (data as! Data).hexadecimal()
//            let mac = hex[4...hex.length - 1].macText
//            plog(data)
//            peripheral.mac = mac
//        }
        if peripheral.name  == "TappLock" {
            self.rx_dfuLock.value = peripheral
            return
        }

        isConnectPeripheral.insert(peripheral)

        if !self.rx_peripherals.value.reduce(false, { $0 || $1 == peripheral }) {
            manager.connect(peripheral, options: nil)
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("连接--> 成功")
        if !self.rx_peripherals.value.reduce(false, { $0 || $1 == peripheral }) {
            addTapplock(peripheral)
        }
        peripheral.discoverServices([CBUUID.init(string: UUID_SERVICE)])
        
        for per in isConnectPeripheral {
            if per === peripheral {
                isConnectPeripheral.remove(per)
                break
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接--> 失败了")
        for model in rx_peripherals.value {
            if model == peripheral {
                rx_peripherals.value.remove(model)
            }
        }
        
        for per in isConnectPeripheral {
            if per === peripheral {
                plog("移除connected")
                isConnectPeripheral.remove(per)
                break
            }
        }
        
        if UIApplication.shared.applicationState == .active {
            scan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("连接--> 断开了")
        for model in rx_peripherals.value {
            if model.peripheral == peripheral {
                rx_peripherals.value.remove(model)
            }
        }
        if UIApplication.shared.applicationState == .active {
            scan()
        }
    }
    
}
