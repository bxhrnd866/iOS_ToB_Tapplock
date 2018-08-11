//
//  UserGroupViewmodel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/8/11.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class UserGroupViewModel: NSObject {
    
    var rx_data: Variable<[GroupsModel]> = Variable([GroupsModel]())
    var rx_step: Variable<RequestStep> = Variable(.none)
    
    override init() {
        super.init()
        
        
        
        
    
        
    }
    
    func loadAPI() {
        self.rx_step.value = .loading
        if ConfigModel.default.user.value?.groups != nil {
            self.rx_data.value = (ConfigModel.default.user.value?.rx_groups.value)!
            self.rx_step.value = .sucess
            return
        }
        provider.rx.request(APIServer.allGroupslist)
            .mapObject(APIResponseData<GroupsModel>.self)
            .subscribe(onSuccess: { [weak self] response in
             
                if response.success {
                    self?.rx_step.value = .sucess
                    if response.data != nil {
                        self?.rx_data.value = response.data!
                        let model = GroupsModel.init()
                        model.groupName = R.string.localizable.allGroup()
                        self?.rx_data.value.insert(model, at: 0)
                    }
                } else {
                    self?.rx_step.value = .errorMessage(mesg: response.codeMessage!)
                }
                
            }) { ( error) in
             self.rx_step.value = .failed
            }.disposed(by: rx.disposeBag)
        
        
    }
    
    
}
