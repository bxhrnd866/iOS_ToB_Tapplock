//
//  ViewController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/5/15.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = TapplockModel()
        model.key1 = "01020304"
        model.key2 = "05060708"
        model.mac = "E4:78:A6:5E:1E:D3"
        model.serialNo = "00000000"
        model.oneAccess = "0"
        model.shareUuid = "-1"
        TapplockManager.default.addTapplockFromAPI(lock: model)
        
        
//        "key1":"01020304","key2":"05060708","mac":"E4:78:A6:5E:1E:D3","serialNo":"00000000","oneAccess":0}
        
        let x = TapplockManager.default
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

