//
//  MenuModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/3.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class MenuViewModel {
   
    var rx_list: Variable<[MenuModel]> = Variable([MenuModel]())
    
    init() {
        
        var m2: MenuModel? = nil
        
        var m3: MenuModel? = nil
        
        if let permissions = ConfigModel.default.user.value?.permissions {
            
            for model in permissions {
                if model.permissionCode == "301" {
                    m2 = MenuModel(R.string.localizable.menuViewAllLocks())
                }
                if model.permissionCode == "302" {
                    m3 = MenuModel(R.string.localizable.menuViewHistory())
                }
            }
        }
        
        let m0 = MenuModel(R.string.localizable.menuProfile())
        
        let m1 = MenuModel(R.string.localizable.menuTapplock())
        m1.select = true
        
        let m4 = MenuModel(R.string.localizable.menuNotification())
        
        let m5 = MenuModel(R.string.localizable.menuTutorial())
        
        let m6 = MenuModel(R.string.localizable.menuSetting())
        
        let m7 = MenuModel(R.string.localizable.menuLogout())
        
        
        rx_list.value.append(m0)
        rx_list.value.append(m1)
        
        if m2 != nil {
           rx_list.value.append(m2!)
        }
        if m3 != nil {
           rx_list.value.append(m3!)
        }
        
        rx_list.value.append(m4)
        rx_list.value.append(m5)
        rx_list.value.append(m6)
        rx_list.value.append(m7)
    
    }
}

