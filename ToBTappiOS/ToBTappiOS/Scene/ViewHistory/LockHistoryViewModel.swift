//
//  LockHistoryViewModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/25.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LockHistoryViewModel: NSObject {
    
    var dictSource = [String : Array<LockHistoryModel>]()

    var page = 1
    var totalPage = 1
    var rx_step: Variable<RequestStep> = Variable(.none)
    
    var userId: Int?
    var lockId: Int?
    var quertType = 1  // 0--finger 1---blue
    
    
    var rx_targetName: Variable<String?> = Variable(nil)
    var rx_beginTime: Variable<Int?> = Variable(nil)
    var rx_endTime: Variable<Int?> = Variable(nil)
    
    
    
    
    override init() {
      super.init()
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
    
    func loadAPI() {
        
        provider.rx.request(APIServer.historyList(userId: userId,
                                                  lockId: lockId,
                                                  targetName: rx_targetName.value,
                                                  beginTime: rx_beginTime.value,
                                                  endTime: rx_endTime.value,
                                                  queryType: quertType,
                                                  size: 20,
                                                  page: page))
            .mapObject(APIResponse<ListModel<LockHistoryModel>>.self)
            .subscribe(onSuccess: { [weak self] response in
                
                if response.success {
                    
                    if let list = response.data?.list {
                        self?.page = (response.data?.pageCurrent)!
                        self?.totalPage = (response.data?.totalPage)!
                        if response.data?.pageCurrent == 1 {
                            self?.dictSource.removeAll()
                        }
                        self?.resetDate(list: list)
                    }
                    self?.rx_step.value = .sucess
                } else {
                    self?.rx_step.value = .errorMessage(mesg: response.codeMessage!)
                }
                
        }).disposed(by: rx.disposeBag)
    }
    
    private func resetDate(list: [LockHistoryModel]) {
        for A in list {
            if A.textTime != nil {
                let keys = dictSource.keys
                if keys.contains(A.textTime!) {
                    var source = dictSource[A.textTime!]
                    source?.append(A)
                    dictSource.updateValue(source!, forKey: A.textTime!)
                } else {
                    let sou = [A]
                    dictSource.updateValue( sou, forKey: A.textTime!)
                }
            }
        }
    }
        
}
