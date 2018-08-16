//
//  BlueDetailViewModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/23.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BlueDetailViewModel: NSObject {
    
    let lock = TapplockManager.default.editingLock
    
    var rx_batteryLabelText = Variable("-")
    var rx_lockStatus = Variable("--")
    var rx_step: Variable<RequestStep> = Variable(.none)
    var rx_update: Variable<Bool> = Variable(false)
    var updateModel: FirmwareModel?
    
    override init() {
        super.init()
        
       lock?.rx_battery.asObservable()
            .filter {
                $0 != nil
            }
            .map {
                "\($0!)"
            }
            .bind(to: rx_batteryLabelText)
            .disposed(by: rx.disposeBag)
        
        if lock?.rx_battery.value == nil {
            lock?.peripheralModel?.sendBatteryCommand()
        }
        
        let status = lock?.rx_status.asObservable().share(replay: 1)
        
        status!.map {
            $0!.textValue
            }.bind(to: rx_lockStatus).disposed(by: rx.disposeBag)
        
        status!.subscribe(onNext: { [weak self] status in
            //刚连接上锁之后,还没有完成Pair,此时不能发指令
            if .connected == status {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    if self?.lock?.peripheralModel?.rx_battery.value == nil {
                        print("再次发送了")
                        self?.lock?.peripheralModel?.sendBatteryCommand()
                    }
                }
            } else {
                self?.rx_batteryLabelText.value = "--"
            }
        }).disposed(by: rx.disposeBag)
    }
    
    func unlockButtonAction() {

        
        
        let lat = ConfigModel.default.locaiton?.latitude
        let long = ConfigModel.default.locaiton?.longitude
       
    
        rx_step.value = .loading
        provider.rx.request(APIServer.updateLockHistory(accessTypes: [0], closeOperateTimes: nil, latitude: lat, longitude: long, location: ConfigModel.default.locaiton?.address, lockId: (lock?.id)!, morseOperateTimes: nil, operateLocalDate: Date().string(custom: "yyyy-MM-dd"), unlockFingerprints: nil, userId: ConfigModel.default.user.value?.id))
            .mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { [weak self] response in
                if response.success {
                    self?.rx_step.value = .sucess
                    self?.lock?.peripheralModel?.sendUnlockCommand()
                } else {
                    self?.rx_step.value = RequestStep.errorMessage(mesg: response.codeMessage)
                }
                
            }) { (error) in
                self.rx_step.value = .failed
        }.disposed(by: rx.disposeBag)
    }
    
    func hardVersionUpdate() {
        if let version = lock?.hardwareVersion {
            provider.rx.request(APIServer.checkFirmwares(hardwareVersion: "0002"))
                .mapObject(APIResponse<FirmwareModel>.self)
                .subscribe(onSuccess: { [weak self] response in

                            self?.updateModel = response.data
                            self?.rx_update.value = true
                
//                    if let hv = self?.lock?.peripheralModel?.rx_firmware.value, let max = response.data?.currentVersion?.toInt() {
//
//                        if max > hv {
//
//                            self?.updateModel = response.data
//                            self?.rx_update.value = true
//
//                            plog(hv)
//                            plog(self?.updateModel)
//                        }
//                    }
                
                }) { ( error) in
                    self.rx_step.value = .failed
                }.disposed(by: rx.disposeBag)
        }
        
        
    }
    
}
