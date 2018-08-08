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
    
    var dataSource = Variable([FingerPrintModel]())
    
    override init() {
        super.init()
        loadAPI()
    }
    
    func loadAPI() {
        
        rx_step.value = .loading
        provider.rx.request(APIServer.userFingerPrint).mapObject(APIResponseData<FingerPrintModel>.self)
            .subscribe(onSuccess: { [weak self] response in
              
                if response.success {
                   self?.rx_step.value = RequestStep.sucess
                    if response.data != nil {
                        for model in response.data! {
                            if model.handType == 0 {
                                self?.leftSource.append(model)
                            } else {
                                self?.rightSource.append(model)
                            }
                        }
                    }
                    
                } else {
                    self?.rx_step.value = RequestStep.errorMessage(mesg: response.codeMessage)
                }
                
            }) { ( error) in
                self.rx_step.value = .failed
            }.disposed(by: rx.disposeBag)
    }
    

    
    
}
