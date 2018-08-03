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
    
    var rx_lockList = Variable(Set<TapplockModel>())
    var rx_lockName: Variable<String?> = Variable(nil)
    var rx_groupId: Variable<Int?> = Variable(nil)
    var rx_authType: Variable<Int> = Variable(0)
    var page = 1
    var totalPage = 1
    var rx_step: Variable<RequestStep> = Variable(.none)
    var rx_loadAll = Variable(false)
    
    override init() {
        super.init()
        TapplockManager.default.rx_myLocks
            .asObservable().bind(to: rx_lockList)
            .disposed(by: rx.disposeBag)
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
        
        provider.rx.request(APIServer.lockList(userId: ConfigModel.default.user.value?.id ?? 9001,lockName: rx_lockName.value, groupId: rx_groupId.value, authType: rx_authType.value, page: page, size: 20))
            .mapObject(APIResponse<ListModel<TapplockModel>>.self)
            .subscribe(onSuccess: { [weak self] response in
                
                if response.success {
                    self?.rx_step.value = .sucess
                    if let list = response.data?.list {
                        
                        self?.page = (response.data?.pageCurrent)!
                        self?.totalPage = (response.data?.totalPage)!
                        self?.rx_loadAll.value = (self?.page)! >= (self?.totalPage)!
                        
                        let _ = list.map({
                            TapplockManager.default.addAPITapplock($0)
                        })
                    }
                    
                } else {
                    self?.rx_step.value = .errorMessage(mesg: response.codeMessage!)
                }
                
        }).disposed(by: rx.disposeBag)
        
        
    }
}
