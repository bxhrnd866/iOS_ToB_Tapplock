//
//  FingerDetailViewModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/24.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FingerDetailViewModel: NSObject {
    
    let lock = TapplockManager.default.editingLock
    var rx_step: Variable<RequestStep> = Variable(.none)
    var leftSource = [FingerPrintModel]()
    var rightSource = [FingerPrintModel]()
    var rx_batteryLabelText = Variable("-")
    var dataSource = Variable([FingerPrintModel]())
    
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
        
        status!.subscribe(onNext: { [weak self] status in
            //刚连接上锁之后,还没有完成Pair,此时不能发指令
            if .connected == status {
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
//                    if self?.lock?.peripheralModel?.rx_battery.value == nil {
//                        print("再次发送了")
//                        self?.lock?.peripheralModel?.sendBatteryCommand()
//                    }
//                }
            } else {
                self?.rx_batteryLabelText.value = "--"
            }
        }).disposed(by: rx.disposeBag)
        
        
        
        
        
        loadAPI()
    }
    
    func loadAPI() {
        
        rx_step.value = .loading
        provider.rx.request(APIServer.userFingerPrint).mapObject(APIResponseData<FingerPrintModel>.self)
            .subscribe(onSuccess: { [weak self] response in
              
                if response.success {
                   
                    if response.data != nil {
                        for model in response.data! {
                            if model.handType == 0 {
                                self?.leftSource.append(model)
                            } else {
                                self?.rightSource.append(model)
                            }
                        }
                        
                    }
                    self?.rx_step.value = RequestStep.sucess
                    
                } else {
                    if response.codeMessage != nil {
                        self?.rx_step.value = RequestStep.errorMessage(mesg: response.codeMessage!)
                    }  else {
                        self?.rx_step.value = .failed
                    }
                    
                }
                
            }) { ( error) in
                self.rx_step.value = .failed
            }.disposed(by: rx.disposeBag)
    }
    

    
    
}
