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
    var rx_loadAll = Variable(false)
    
    override init() {
       
    }
    
    
    func loadAPI() {
       plog(ConfigModel.default.user.value?.groupIds)
    
        provider.rx.request(APIServer.lockList(userId: nil,lockName: rx_lockName.value, groupIds: rx_groupId.value != nil ? String(self.rx_groupId.value ?? -1) : ConfigModel.default.user.value?.groupIds, authType: nil, page: page, size: 20))
            .mapObject(APIResponse<ListModel<TapplockModel>>.self)
            .subscribe(onSuccess: { [weak self] response in
                
                if response.success {
                    self?.rx_step.value = .sucess
                    if let list = response.data?.list {
                    
                        self?.page = (response.data?.pageCurrent)!
                        self?.totalPage = (response.data?.totalPage)!
                        self?.rx_loadAll.value = (self?.page)! >= (self?.totalPage)!
                        if self?.page == 1 {
                            self?.rx_locks.value = list
                        } else {
                            self?.rx_locks.value += list
                        }
                    }
                    
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
    
    func loadRefresh() {
        page = 1
        self.loadAPI()
    }
    
    func loadMore() {
        if totalPage > page {
            page += 1
            self.loadAPI()
        } else {
            self.rx_loadAll.value = self.page >= self.totalPage
        }
    }
}
