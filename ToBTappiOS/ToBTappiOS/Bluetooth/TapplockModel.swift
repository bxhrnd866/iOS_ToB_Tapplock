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

    var id: Int?
    var rx_lockName: Variable<String?> = Variable(nil)
    var rx_imageUrl: Variable<String?> = Variable(nil)
    var key1: String?
    var key2: String?
    var mac: String?
    var oneAccess: String?
    var serialNo: String?
    var shareUuid: String?  // -1自己的锁
 
    //连接状态
    public var rx_status: Variable<CBPeripheralState?> = Variable(.disconnected)
    //可观察设备电量
    public var rx_battery: Variable<Int?> = Variable(nil)
    
    //物理层蓝牙类
    var peripheralModel: PeripheralModel? {
        didSet {
            peripheralModel?.key1 = self.key1
            peripheralModel?.key2 = self.key2
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
    
    // 显示固件提示
    func showToast() {
//        let window = UIApplication.shared.delegate?.window!
//        let x =  window?.rootViewController?.presentedViewController
//        
//        let alertController = CFAlertViewController(title: R.string.localizable.lockNewFirmwareVersionTotals(),
//                                                    message: nil,
//                                                    textAlignment: .left,
//                                                    preferredStyle: .alert,
//                                                    didDismissAlertHandler: nil)
//        alertController.shouldDismissOnBackgroundTap = false
//        alertController.backgroundStyle = .blur
//        alertController.backgroundColor = UIColor.clear
//        
//        let ok = CFAlertAction(title: R.string.localizable.oK(), style: .Default, alignment: .justified, backgroundColor: UIColor.themeColor, textColor: nil, handler: nil)
//        
//        alertController.addAction(ok)
//        x?.present(alertController, animated: true, completion: nil)
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override init() {
        super.init()
    }

}

extension TapplockModel {
    var lockName: String? {
        set {
            rx_lockName.value = newValue
        }
        get {
            return rx_lockName.value
        }
    }

    var imageUrl: String? {
        set {
            rx_imageUrl.value = newValue
        }
        get {
            return rx_imageUrl.value
        }
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
    
    //更新Tapplock信息
    public func update(_ model: TapplockModel) {
        
        if (self.id == nil) {
            id = model.id
            key1 = model.key1
            key2 = model.key2
            mac = model.mac
            oneAccess = model.oneAccess
            serialNo = model.serialNo
            shareUuid = model.shareUuid
        }
        
        lockName = model.lockName
        imageUrl = model.imageUrl
    }
}










