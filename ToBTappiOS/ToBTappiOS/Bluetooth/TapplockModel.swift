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

    var corpName: String?         // 公司名
    var groupName: String?        //组名字
    var firmwareVersion: String?  //固件版本
    var hardwareVersion: String?  //硬件版本
    var id: Int?                  //锁id
    var lastUpdateTime: Int?      //最后更新时间
    var latitude: String?         //纬度
    var longitude: String?        //经度
    var lockName: String?         //锁名称
    var lockStatus: Int?          //锁状态 0-no action 1-pending 2-complete
    var mac: String?
    var morseStatus: Int?        //摩斯码状态0-未同步 1-已同步
    
    var key1: String?
    var serialNo: String?
    


    //连接状态
    public var rx_status: Variable<CBPeripheralState?> = Variable(.disconnected)
    //可观察设备电量
    public var rx_battery: Variable<Int?> = Variable(nil)
    
    //物理层蓝牙类
    var peripheralModel: PeripheralModel? {
        didSet {
            peripheralModel?.key1 = self.key1

            peripheralModel?.serialNumber = self.serialNo
            if peripheralModel?.isFirstPairing == false {
                peripheralModel?.sendPairingCommand()
            }
        }
    }

    //Tapplock模型是否与物理蓝牙设备为同一个设备
    public func contains(_ peripheralModel: PeripheralModel) -> Bool {
        
        if self.peripheralModel != nil {
            return peripheralModel == self.peripheralModel
        } else if peripheralModel.rx_mac.value?.macValue == mac?.macValue {
            self.peripheralModel = peripheralModel
            bindData()
            return true
        } else {
            return false
        }
    }

    //绑定Tapplock数据,设置回掉
    func bindData() {
        
       peripheralModel?.rx_battery.asObservable().bind(to: rx_battery).disposed(by: rx.disposeBag)
        
        peripheralModel?.rx_status.asObservable().bind(to: rx_status).disposed(by: rx.disposeBag)
        
        rx_status.asObservable().subscribe(onNext: { [weak self] status in
            if status == .disconnected {
                self?.peripheralModel = nil
            }
        }).disposed(by: rx.disposeBag)
        
        if self.peripheralModel?.isFirstPairing == false {
            peripheralModel?.rx_hardware.asObservable().filter({ $0 != nil }).map({ $0! }).subscribe(onNext: { [weak self] hv in
                
                let fv = self?.peripheralModel?.rx_firmware.value?.toInt()
                plog("--------------> \(hv)")
                if fv != nil {
                    self?.checkFirwareVersion(hv: hv, fv: fv!)
                }
            }).disposed(by: rx.disposeBag)
        }
    }
    
    // 查看固件版本
    func checkFirwareVersion(hv: String,fv: Int) {
//        _ = provider.rx.request(ApiService.UpdateFirmware(hardVersion: hv)).mapObject(APIResponse<UpdateFWModel>.self).subscribe(onSuccess: { [weak self] (response) in
//            if let list = response.data {
//                let max = list.currentVersion?.toInt()
//                if max! > fv {
//                    self?.showToast()
//                }
//            }
//        })
    }
    


    required init?(map: Map) {
        super.init()
    }
    
    override init() {
        super.init()
    }

    func mapping(map: Map) {
        corpName <- map["corpName"]
        groupName <- map["groupName"]
        firmwareVersion <- map["firmwareVersion"]
        hardwareVersion <- map["hardwareVersion"]
        id <- map["id"]
        lastUpdateTime <- map["lastUpdateTime"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        lockName <- map["lockName"]
        lockStatus <- map["lockStatus"]
        mac <- map["mac"]
        morseStatus <- map["morseStatus"]
    }
    
    func updateModel(key: String, seriaNo: String) {
        self.key1 = key
        self.serialNo = seriaNo
    }
    
}










