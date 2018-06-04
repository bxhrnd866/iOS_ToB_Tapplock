//
//  TapplockModel.swift
//  ToBTapplcok
//
//  Created by TapplockiOS on 2018/4/11.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import ObjectMapper
import RxCocoa
import RxSwift

class TapplockModel: NSObject,Mappable {
  
    
    var id: Int? //锁id
    var lockName: String? //锁名字
    var key1: String? //
    var key2: String? //
    var mac: String?  // mac地址
    var oneAccess: String?
    var serialNo: String? //写锁用
    var shareUuid: String? // 分享 -1 为自己
    var imageUrl: String?  //锁图像
    
    override init() {
        super.init()
    }
    // 蓝牙模型
    var peripheral: BLEPeripheral? {
        didSet {
            peripheral?.key1 = self.key1
            peripheral?.key2 = self.key2
            peripheral?.serialNumber = self.serialNo
            if peripheral?.isFirstPairing == false {
                peripheral?.sendPairingCommand()
            }
        }
    }
    
    public func contains(_ peropheralModel: BLEPeripheral) -> Bool {
        if self.peripheral != nil {
            return peropheralModel == self.peripheral
        } else if mac?.macValue == peropheralModel.rx_mac.value?.macValue {
            self.peripheral = peropheralModel
            bindData()
            return true
        } else {
            return false
        }
    }
    
    func bindData() {
        
        peripheral?.rx_staus.asObservable().subscribe(onNext: { [weak self] status in
            if status == .disconnected {
                self?.peripheral = nil
            }
        }).disposed(by: rx.disposeBag)
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        imageUrl <- map["imageUrl"]
        key1 <- map["key1"]
        key2 <- map["key2"]
        mac <- map["mac"]
        lockName <- map["lockName"]
        oneAccess <- map["oneAccess"]
        serialNo <- map["serialNo"]
        shareUuid <- map["shareUuid"]
    }
  
    deinit {
        plog("tapplockModel销毁了")
    }
}


let TL1 = "0001"
let TL2 = "0002"

// 设备类型
enum TapplockType: String {
    case typeA = "0001"
    case typeB = "0100"
    case typeC = "0002"
    case typeD = "0200"
    
    var deviceType: String! {
        switch self {
        case .typeA,.typeB:
            return TL1
        case .typeC,.typeD:
            return TL2
        }
    }
    
}


