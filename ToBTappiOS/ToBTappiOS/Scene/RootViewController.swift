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
        
        if ConfigModel.default.user.value == nil {
            provider.rx.request(APIServer.oauthToken(grant_type: oauth_client_credentials, refresh_token: nil)).mapObject(BasicTokenModel.self) .subscribe(onSuccess: { response in
                 plog(response)
//                 UserDefaults.standard.set(response.access_token, forKey: n_basicToKenKey)
            }).disposed(by: rx.disposeBag)
        }
        
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
                
            
                _ = CLLocationManager.promise().firstValue.done({ location in
                    let xm = CLGeocoder.init()
                    let md = AddressModel()
                    md.location = location
                    _ = xm.reverseGeocode(location: location).firstValue.done({ [weak self] cl in
                        let add = "\(cl.country ?? "")\(cl.locality ?? "")\(cl.subLocality ?? "")\(cl.thoroughfare ?? "")"
                        md.address = add
                        ConfigModel.default.locaiton = md
                    })
                })
            
            } else {
                
                
                self.performSegue(withIdentifier: R.segue.rootViewController.showLoginSb, sender: self)
            }
        }
    }
    

}
