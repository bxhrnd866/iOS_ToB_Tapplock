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
    
    var lockList = Variable([TapplockModel]())
    
    override init() {
        for _ in 0...10 {
            let md = TapplockModel()
            lockList.value.append(md)
        }
        
    }
    
}
