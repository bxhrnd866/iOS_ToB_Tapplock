//
//  TapplockManager.swift
//  ToBTapplcok
//
//  Created by TapplockiOS on 2018/4/10.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxCocoa
import RxSwift
import NSObject_Rx
let UUID_SERVICE = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
let DFU_SERVICE = "00001530-1212-EFDE-1523-785FEABCD123"
let UUID_Characteristic_SEND = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
let UUID_Characteristic_RECIEVE = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"


final class TapplockManager: NSObject {
    
    static let `default` = TapplockManager()
    
    // 连接过的锁
 
    var rx_mylocks: BehaviorRelay<[TapplockModel]> = BehaviorRelay(value: [TapplockModel]())
    
    // 扫描的设备
    var scan_peripheral: Variable<Set<BLEPeripheral>> = Variable(Set<BLEPeripheral>())
    
    // 编辑的锁
    var isEditLock: TapplockModel?
    
    var manager: CBCentralManager!
    
    //Tapplock DFU升级时的对象
    var tapplockPeripheral: BehaviorRelay<CBPeripheral?> = BehaviorRelay(value: nil)
    
    var bluetoothState: CBManagerState {
        return manager.state
    }
    
    override init() {
        super.init()
        manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
        
    }
    //Reset方法,用户退出时调用
    public func reset() {
        stop()
        rx_mylocks.accept([])
        scan_peripheral.value = []
        isEditLock = nil
        
    }
    
    public func scan() {
        manager.stopScan()
        if manager.state == .poweredOn {
           manager.scanForPeripherals(withServices: [CBUUID.init(string: UUID_SERVICE),CBUUID.init(string: DFU_SERVICE)], options: nil)
        }
    }
    
    public func stop() {
        manager.stopScan()
        for model in self.rx_mylocks.value {
            if let per = model.peripheral {
                manager.cancelPeripheralConnection(per.peripheral)
            }
        }
    }

    // 从API获取的新锁添加
    public func addTapplockFromAPI(lock: TapplockModel) {
        for mylock in rx_mylocks.value {
            if mylock.mac?.macValue == lock.mac?.macValue {
                return
            }
        }
        
        for peripheralModel in scan_peripheral.value {
            if lock.contains(peripheralModel) {
                scan_peripheral.value.remove(peripheralModel)
            }
        }
        
        var oldArr = self.rx_mylocks.value
        oldArr.append(lock)
        self.rx_mylocks.accept(oldArr)
        
    }
    // 扫描到锁时添加
    func addPeripheralFromScan(_ peripheral: CBPeripheral) {
        if !self.rx_mylocks.value.reduce(false, { $0 || $1.peripheral?.peripheral == peripheral }) ||
            !self.scan_peripheral.value.reduce(false, { $0 || $1.peripheral == peripheral}) {
            let peripheralmodel = BLEPeripheral.init(peripheral)
            self.scan_peripheral.value.insert(peripheralmodel)
        }
    }
    // BLE与锁模型关联
    public func loackConnectModel(_ peripheralmodel: BLEPeripheral) {
        if self.rx_mylocks.value.reduce(false, { $0 || $1.contains(peripheralmodel)}) == true {
            self.scan_peripheral.value.remove(peripheralmodel)
        }
    }
    
}

extension TapplockManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            plog("蓝牙打开了")
            self.scan()
        default:
            break
        }
    }
    
    // MARK:发现设备
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        plog("发现设备")
        if peripheral.name == "TappLock" {
            self.tapplockPeripheral.accept(peripheral)
            // MARK: startDFU
            return
        }
        
        if !self.scan_peripheral.value.reduce(false, {$0 || $1.peripheral == peripheral}) {
            addPeripheralFromScan(peripheral)
            manager.connect(peripheral, options: nil)
        }
    }
    
    // MARK: 连接成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        plog("连接成功")
        peripheral.discoverServices([CBUUID.init(string: UUID_SERVICE)])
    }
    
    // MARK: 连接断开
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        plog("连接断开")
        
        if tapplockPeripheral.value == peripheral {
            tapplockPeripheral.accept(nil)
        }
        
        for model in scan_peripheral.value {
            if model.peripheral == peripheral {
                plog("remove一个")
                scan_peripheral.value.remove(model)
            }
        }
        if UIApplication.shared.applicationState == .active {
            scan()
        }
    }
    // MARK: 连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        plog("连接失败")
        for model in scan_peripheral.value {
            if model.peripheral == peripheral {
                scan_peripheral.value.remove(model)
            }
        }
        if UIApplication.shared.applicationState == .active {
            scan()
        }
    }
    
}

