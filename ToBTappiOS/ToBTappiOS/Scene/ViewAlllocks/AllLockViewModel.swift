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
    
    override init() {
        for _ in 0...10 {
            let md = TapplockModel()
            rx_locks.value.append(md)
        }
    }
    
}
