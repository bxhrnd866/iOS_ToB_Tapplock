//
//  PeripheralHistory.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/6/21.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import Foundation
extension PeripheralModel {
    
    
    func lockCollectHistory(response: BluetoothResponse) {
        guard let hv = self.rx_hardware.value else {
            return
        }
        switch hv {
        case aKind:
            if let value = response.value {
                TL1Update(value:value)
            } else{
                plog("历史为空")
            }
            
        case bKind:
            TL2CollectData(response: response)
            historyNumer(response: response)
        default:
            break
        }
    }
    
    func TL1Update(value: String) {
      
        let vl = value.inserting(separator: ",", every: 4)
        let source = vl.components(separatedBy: ",")
        
//        _ = provider.rx.request(APIService.V1addHistoryFingerprint(fingerprintIndex: source, mac: self.rx_mac.value!, uuid: (ConfigModel.default.user.value?.uuid)!))
//            .mapObject(APIResponse<EmptyModel>.self)
//            .subscribe(onSuccess: { _ in
//                plog("一代指纹成功")
//            })
    }
    
    func TL2CollectData(response: BluetoothResponse){
        
        guard let value = response.value else {
            plog("历史为空")
            return
        }
        
        if value.length != 24 {
            return
        }
        do {
            let index = value[0...3]
            let open = value[4...13]
            let close = value[14...23]
            let openTime = hexCovertoTamp(time: open)
            let closeTime = hexCovertoTamp(time: close)
            
            let dict = ["closeTime" : closeTime,"openTime" : openTime,"fingerIndex" : index] as [String : Any]
            self.historys.append(dict)
        }
    }
    
    func historyNumer(response: BluetoothResponse) {
        guard let num = response.historyNumber else {
            return
        }
        
        if num == self.rx_historyTotals.value - 1 {
            let arr = Array(self.historys.reversed())
//            _ = provider.rx.request(APIService.AddHistoryFingerprint(fingerprintIndex: arr, mac: self.rx_mac.value!, uuid: (ConfigModel.default.user.value?.uuid)!))
//                .mapObject(APIResponse<EmptyModel>.self)
//                .subscribe(onSuccess: {  response in
//                    plog("二代指纹成功")
//
//                })
        }
    }
    
}
