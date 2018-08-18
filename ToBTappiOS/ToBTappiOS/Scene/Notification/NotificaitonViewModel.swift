//
//  NotificaitonViewModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/8/2.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class NotificationViewModel: NSObject {
    
    var rx_data: Variable<[NoficationModel]> = Variable([NoficationModel]())
    
    var rx_refresh: Variable<Bool> = Variable(false)
    
    override init() {
       
        super.init()
        let usermanger = UserDefaults(suiteName: "group.tapplockNotificaitonService.com")
        let array = usermanger?.object(forKey: "NotificationContent") as? [[String: String]]
        
        if array != nil {
            let _ = array!.map {
            
                let model = NoficationModel()
                
                model.title = $0["title"]
                model.body = $0["body"]
                model.timeText = $0["time"]
                
                rx_data.value.append(model)
            }
            self.rx_refresh.value = true
            
        }
        
        
    }
    
}


