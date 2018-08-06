//
//  TapplockViewModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/18.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TapplockViewModel: NSObject {
    
    var rx_lockList = Variable(Array<TapplockModel>())
    var rx_lockName: Variable<String?> = Variable(nil)
    var rx_groupId: Variable<Int?> = Variable(nil)
    var rx_authType: Variable<Int> = Variable(0)
    var page = 1
    var totalPage = 1
    var rx_step: Variable<RequestStep> = Variable(.none)
    var rx_loadAll = Variable(false)
    
    override init() {
        super.init()
        
        
        TapplockManager.default.rx_peripherals
            .asDriver()
            .drive(onNext: { [weak self] _ in
               self?.contains()
        }).disposed(by: rx.disposeBag)
        
    }
    
    
    private func contains() {
        for model in TapplockManager.default.rx_peripherals.value {
            if self.rx_lockList.value.reduce(false, { $0 || $1.contains(model) }) {
                plog("找到一个")
                break
            }
        }
        
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
    
    func loadAPI() {
        
        plog(ConfigModel.default.user.value?.groupIds)
        
        provider.rx.request(APIServer.lockList(userId: ConfigModel.default.user.value?.id ?? 9001,lockName: rx_lockName.value, groupIds: rx_groupId.value != nil ? String(self.rx_groupId.value ?? -1) : ConfigModel.default.user.value?.groupIds, authType: rx_authType.value, page: page, size: 20))
            .mapObject(APIResponse<ListModel<TapplockModel>>.self)
            .subscribe(onSuccess: { [weak self] response in
                
                if response.success {
                    self?.rx_step.value = .sucess
                    if let list = response.data?.list {
                        
                        self?.page = (response.data?.pageCurrent)!
                        self?.totalPage = (response.data?.totalPage)!
                        self?.rx_loadAll.value = (self?.page)! >= (self?.totalPage)!
                        if self?.page == 1 {
                            self?.rx_lockList.value = list
                        } else {
                            self?.rx_lockList.value += list
                        }
                        self?.contains()
                    }
                    
                } else {
                    self?.rx_step.value = .errorMessage(mesg: response.codeMessage!)
                }
                
        }).disposed(by: rx.disposeBag)
        
        
    }
}
