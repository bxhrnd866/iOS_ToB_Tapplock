//
//  RootViewController.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/10.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import PromiseKit
import CoreLocation
import RxSwift
import RxCocoa
class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //查询是初次使用
        let used = UserDefaults.standard.bool(forKey: "used")
        
        //此处需要延时执行,页面刚启动时Segue没有初始化完成跳转会失效
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            //初次使用=>showTutorialSegue
            if !used {
                UserDefaults.standard.set(true, forKey: "used")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: R.segue.rootViewController.showTutorialSegue, sender: self)
            }
            else if ConfigModel.default.user.value != nil {
                
                self.performSegue(withIdentifier: R.segue.rootViewController.showHomeSB, sender: self)
                
            
//               _ = CLLocationManager.requestLocation().lastValue.done({ (location) in
//                    _ = provider.rx.request(ApiService.UpdateLocktion(latitude: String(location.coordinate.latitude),
//                                                                      longitude: String(location.coordinate.longitude),
//                                                                      uuid: ConfigModel.default.user.value!.uuid))
//                        .mapObject(APIResponse<EmptyModel>.self)
//                        .subscribe(onSuccess: { response in
//
//                            print(response)
//                        })
//                })

            } else {
                self.performSegue(withIdentifier: R.segue.rootViewController.showLoginSb, sender: self)
            }
        }
    }
    

}
