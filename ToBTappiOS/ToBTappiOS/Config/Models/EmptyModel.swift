//
//  EmptyModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/5/18.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import ObjectMapper

//空模型,上传数据时成功失败回掉方法使用
class EmptyModel: Mappable {
    
    // MARK: JSON
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        
    }
    
}
