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
import NSObject_Rx
import CoreBluetooth
import CoreLocation
import CFAlertViewController


let UUID_SERVICE = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
let DFU_SERVICE = "00001530-1212-EFDE-1523-785FEABCD123"
let UUID_Characteristic_SEND = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
let UUID_Characteristic_RECIEVE = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
//锁控制中心主类
final class TapplockManager: NSObject {
   
    //可观察的已添加的锁列表集合
    var rx_myLocks: Variable<Set<TapplockModel>> = Variable(Set<TapplockModel>())
    //可观察的未添加的锁列表集合
    var rx_peripherals = Variable(Set<PeripheralModel>())
    //可观察的正在编辑的锁列表集合
    var editingLock: TapplockModel? = nil
    // 进入DFU的锁
    var rx_dfuLock: Variable<CBPeripheral?> = Variable(nil)
    
    //蓝牙管理器
    var manager: CBCentralManager!
    
    var isConnectPeripheral = [CBPeripheral]()
    
    //蓝牙管理器状态
    var bluetoothState: CBManagerState {
        get {
            return manager.state
        }
    }

    //单例
    static let `default` = TapplockManager()
    //初始化
    private override init() {
        super.init()
        manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
    }
    
    func reInitManager() -> Void {
        manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
    }
    
    //Reset方法,用户退出时调用
    public func reset() {
        stop()
        rx_myLocks.value = []
        rx_peripherals.value = []
        editingLock = nil
    }
    
    //从rx_myLocks中删除锁
    public func deleteTapplock(_ lock: TapplockModel) {
        if lock == editingLock {
            editingLock = nil
        }
        if rx_myLocks.value.contains(lock) {
            rx_myLocks.value.remove(lock)
        }
    }
    
    // 从API获取的新锁添加
    public func addTapplock(_ lock: TapplockModel) {
        for myLock in rx_myLocks.value {
            if myLock.mac?.macValue == lock.mac?.macValue {
//                myLock.update(lock)
                return
            }
        }
        
        for peripheralModel in rx_peripherals.value {
            if lock.contains(peripheralModel) {
                self.rx_peripherals.value.remove(peripheralModel)
            }
        }
        rx_myLocks.value.insert(lock)
    }

    // 扫描到锁时添加
    public func addTapplock(_ peripheral: CBPeripheral) {
        
        if !(self.rx_myLocks.value.reduce(false, { $0 || $1 == peripheral }) ||
                self.rx_peripherals.value.reduce(false, { $0 || $1 == peripheral })) {
            
            let peripheralModel = PeripheralModel.init(peripheral)
            self.rx_peripherals.value.insert(peripheralModel)
            
        }
    }
    // BLE与锁模型关联
    func lockConnectModel(_ peripheralModel: PeripheralModel) {
        if self.rx_myLocks.value.reduce(false, { $0 || $1.contains(peripheralModel) }) {
            plog("remove")
            self.rx_peripherals.value.remove(peripheralModel)
        }
    }
    
    //启动蓝牙扫描
    public func scan() {
        manager.stopScan()
        manager.scanForPeripherals(withServices: [CBUUID.init(string: UUID_SERVICE),CBUUID.init(string: DFU_SERVICE)], options: nil)
    }
    
    //停止蓝牙服务
    public func stop() {
        manager.stopScan()
        for lock in rx_myLocks.value {
            if let peripheral = lock.peripheralModel?.peripheral {
                manager.cancelPeripheralConnection(peripheral)
            }
        }
    }

    
    // 打开定位权限
    func locationAuthorizationStatus(peripheral: CBPeripheral) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            if !self.rx_peripherals.value.reduce(false, { $0 || $1 == peripheral }) {
                manager.connect(peripheral, options: nil)
            }
            break
        case .restricted, .denied:
            showToast()
            break
        }
    }
    
    func showToast() {
//        let window = UIApplication.shared.delegate?.window!
//        let x =  window?.rootViewController?.presentedViewController
//
//        let alertController = CFAlertViewController(title: R.string.localizable.lockOpenLocationService(),
//                                                    message: nil,
//                                                    textAlignment: .left,
//                                                    preferredStyle: .alert,
//                                                    didDismissAlertHandler: nil)
//        alertController.shouldDismissOnBackgroundTap = false
//        alertController.backgroundStyle = .blur
//        alertController.backgroundColor = UIColor.clear
//
//        let okAction = CFAlertAction(title: R.string.localizable.goToSetting(), style: .Default, alignment: .justified, backgroundColor: UIColor.themeColor, textColor: nil) { (action) in
//            let url = URL(string: UIApplicationOpenSettingsURLString)
//            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//
//        }
//
//        alertController.addAction(okAction)
//        x?.present(alertController, animated: true, completion: nil)
    }

   
  
}
// MARK: 蓝牙相关
extension TapplockManager: CBCentralManagerDelegate {
    
    //系统蓝牙状态更新回掉
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
        
        if let data = advertisementData["kCBAdvDataManufacturerData"] {
            let hex = (data as! Data).hexadecimal()
            plog(hex)
            let mac = hex[4...hex.length - 1].macText
            
            for model in rx_myLocks.value {
                if model.mac! == mac {
                    plog(model.id)
                    peripheral.lockId = model.id
                    break
                }
            }
        }
        
        if peripheral.name  == "TappLock" {
            self.rx_dfuLock.value = peripheral
            return
        }
        
        isConnectPeripheral.append(peripheral)
        
//        locationAuthorizationStatus(peripheral: peripheral)
        
        if !self.rx_peripherals.value.reduce(false, { $0 || $1 == peripheral }) {
            plog(peripheral.name)
            manager.connect(peripheral, options: nil)
        }
        
    }
    // 连接成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("连接--> 成功")
        if !self.rx_peripherals.value.reduce(false, { $0 || $1 == peripheral }) {
            addTapplock(peripheral)
        }
        isConnectPeripheral.removeAll()
        peripheral.discoverServices([CBUUID.init(string: UUID_SERVICE)])
    }
    
    //连接失败回掉
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接--> 失败了")
        for model in rx_peripherals.value {
            if model == peripheral {
                rx_peripherals.value.remove(model)
            }
        }
    }
    
    //连接断开回掉
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("连接--> 断开了")
        for model in rx_peripherals.value {
            if model.peripheral == peripheral {
                rx_peripherals.value.remove(model)
            }
        }
    }
    
    
}
