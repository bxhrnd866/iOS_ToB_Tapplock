//
//  TapplockModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/11/28.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import CoreBluetooth
import CFAlertViewController
//Tapplock模型类
class TapplockModel: NSObject, Mappable {

    var battery: String?
    var corpName: String?         // 公司名
    var groupName: String?        // 组名字
    var firmwareVersion: String?  // 固件版本
    var hardwareVersion: String?  // 硬件版本
    var id: Int?                  // 锁id
    var lastUpdateTime: Int?      // 最后更新时间
    var latitude: String?         // 纬度
    var longitude: String?        // 经度
    var location: String?         // 地理位置
    var lockName: String?         // 锁名称
    var lockStatus: Int?          // 锁状态-1-等待删除 0-指纹未同步 1-已同步
    var mac: String?
    var morseStatus: Int?        //摩斯码状态0-未同步 1-已同步

    var key1: String?
    var serialNo: String?
    var authKey: String?
   
    
    //物理层蓝牙类
    var peripheralModel: PeripheralModel?
    
    //连接状态
    public var rx_status: Variable<CBPeripheralState?> = Variable(.disconnected)
    //可观察设备电量
    public var rx_battery: Variable<Int?> = Variable(nil)
    
    //Tapplock模型是否与物理蓝牙设备为同一个设备
    public func contains(_ peripheralModel: PeripheralModel) -> Bool {

        if self.peripheralModel != nil {
            return peripheralModel == self.peripheralModel
        } else if peripheralModel.rx_mac.value == mac {
            self.peripheralModel = peripheralModel
            bindData()
            return true
        } else {
            return false
        }
    }
    
    func bindData() {
        plog("绑定数据---> \(self.lockName)")
        
        peripheralModel?.rx_battery.asObservable().bind(to: rx_battery).disposed(by: rx.disposeBag)
        
        peripheralModel?.rx_status
            .asObservable()
            .subscribe(onNext: { [weak self] state in
                
                self?.rx_status.value = state
                
                if state == .disconnected {
                    self?.peripheralModel = nil
                }
            
        }).disposed(by: rx.disposeBag)
        
    }

    //更新Tapplock信息
    public func update(_ model: TapplockModel) {
        battery = model.battery
        hardwareVersion = model.hardwareVersion
        lastUpdateTime = model.lastUpdateTime
        latitude = model.latitude
        longitude = model.longitude
        lockName = model.lockName
        lockStatus = model.lockStatus
        morseStatus = model.morseStatus
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override init() {
        super.init()
    }

    func mapping(map: Map) {
        battery <- map["battery"]
        corpName <- map["corpName"]
        groupName <- map["groupName"]
        firmwareVersion <- map["firmwareVersion"]
        hardwareVersion <- map["hardwareVersion"]
        id <- map["id"]
        lastUpdateTime <- map["lastUpdateTime"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        location <- map["location"]
        lockName <- map["lockName"]
        lockStatus <- map["lockStatus"]
        mac <- map["mac"]
        morseStatus <- map["morseStatus"]
        key1 <- map["key1"]
        serialNo <- map["serialNo"]
        authKey <- map["authKey"]
    }
    

    
    
   
    
}










