//
//  BluetoothHistoryViewModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/19.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import RxSwift

class BluetoothHistoryViewModel: NSObject {
    public var rx_errorMessage: Variable<String?> = Variable(nil)
    public var rx_historys = Variable(Array<BluetoothHistoryModel>())
    public var totalPage = 1
    public var page = 1
    public var rx_loading = Variable(false)
    public var rx_loadAll = Variable(false)
    
    var dictSource = [String : Array<BluetoothHistoryModel>]()
    
    

    
    override init() {
        super.init()
        loadHistory(page: 1)
    }

    func loadMoreHistory() {
        if totalPage > page {
            loadHistory(page: page + 1)
        } else {
            self.rx_loadAll.value = self.page >= self.totalPage
        }
    }

    func refresh() {
        loadHistory(page: 1)
    }

    func loadHistory(page: Int = 1) {
        rx_loading.value = true
//        _ = provider.rx.request(ApiService.BluetoothHistory(uuid: (ConfigModel.default.user.value?.uuid)!, page: page, size: 20))
//                .mapObject(APIResponse<ListModel<BluetoothHistoryModel>>.self)
//                .subscribe(onSuccess: { [weak self] response in
//                    if let list = response.data?.list {
//                        self?.page = (response.data?.pageCurrent)!
//                        self?.totalPage = (response.data?.totalPage)!
//                       
//                        self?.rx_loadAll.value = (self?.page)! >= (self?.totalPage)!
//
//                        if response.data?.pageCurrent == 1 {
////                            self?.rx_historys.value = list
//                            self?.dictSource.removeAll()
//                        } else {
////                            self?.rx_historys.value += list
//                        }
//                        self?.resetDate(list: list)
//                        self?.rx_loading.value = false
//                    }
//                })
    }
    
    func resetDate(list: [BluetoothHistoryModel]) -> Void {
       
        for A in list {
            
            if A.day != nil {
                let keys = dictSource.keys
                
                if keys.contains(A.day!) {
                   
                    var source = dictSource[A.day!]
                    source?.append(A)
                    dictSource.updateValue(source!, forKey: A.day!)
                } else {
                    let sou = [A]
                    dictSource.updateValue( sou, forKey: A.day!)
                }
               
            }
        }
        
    }
    
}
