//
//  AllLockViewModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AllLockViewModel: NSObject {
    
    var rx_locks = Variable(Array<TapplockModel>())
    
    var rx_lockName: Variable<String?> = Variable(nil)
    var rx_groupId: Variable<Int?> = Variable(nil)
    var page = 1
    var totalPage = 1
    var rx_step: Variable<RequestStep> = Variable(.none)
    
    override init() {
        for _ in 0...10 {
            let md = TapplockModel()
            rx_locks.value.append(md)
        }
    }
    
    
    func loadAPI() {
        
        provider.rx.request(APIServer.lockList(userId: nil,lockName: rx_lockName.value, groupId: rx_groupId.value, authType: 0, page: page, size: 20))
            .mapObject(APIResponse<ListModel<TapplockModel>>.self)
            .subscribe(onSuccess: { [weak self] response in
                
                if response.success {
                    self?.rx_step.value = .sucess
                    if let list = response.data?.list {
                    
                        self?.page = (response.data?.pageCurrent)!
                        self?.totalPage = (response.data?.totalPage)!
                        
                        if self?.page == 1 {
                            self?.rx_locks.value = list
                        } else {
                            self?.rx_locks.value += list
                        }
                    }
                    
                } else {
                    self?.rx_step.value = .errorMessage(mesg: response.codeMessage!)
                }
                
            }).disposed(by: rx.disposeBag)
    }
    
    func loadRefresh() {
        page = 1
        self.loadAPI()
    }
    
    func loadMore() {
        if totalPage > page {
            page += 1
            self.loadAPI()
        } else {
            self.rx_step.value = .failed
        }
    }
}
