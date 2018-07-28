//
//  ConfigModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/5/18.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
class ConfigModel: NSObject {
    
    static let `default` = ConfigModel()
    // 用户模型
    var user: Variable<UserModel?> = Variable(nil)
    
    var language: Language!
    //推送Token
    var pushToken: String?
    
    var locaiton:  AddressModel? // 定位
    
    //Set推送Token
    func setpushToken(data: String) {
        pushToken = data
        if (pushToken != nil && user.value != nil) {

            
            provider.rx.request(APIServer.userUpdate(fcmDeviceToken: pushToken,
                                                     firstName: nil,
                                                     groupIds: nil,
                                                     lastName: nil,
                                                     permissionIds: nil,
                                                     phone: nil,
                                                     photoUrl: nil,
                                                     sex: nil))
                .mapObject(APIResponse<UserModel>.self).subscribe(onSuccess: { [weak self] response in
                    
                    plog(response)
                }).disposed(by: rx.disposeBag)
            
        }
    }
    
    private override init() {
        //设置语言
        super.init()
        let myLanguage: String? = UserDefaults.standard.object(forKey: language_model_key) as? String

        if myLanguage != nil && myLanguage! != "" {
            language = Language.init(myLanguage!)
        } else {
            let preferredLang = (UserDefaults.standard.object(forKey: "AppleLanguages") as! Array<String>).first
            
            language = Language.init(preferredLang!)
        }

        
        //设置用户
        let userStr: String? = UserDefaults.standard.value(forKey: user_saveKey) as? String
        if userStr != nil {
            if let user = UserModel(JSONString: userStr!) {
                self.user.value = user
            }
        }
        user.asObservable().subscribe(onNext: { [weak self] model in
            
            guard let md = model else {
                UserDefaults.standard.removeObject(forKey: user_saveKey)
                UserDefaults.standard.synchronize()
                TapplockManager.default.reset()
                return
            }
            if self?.pushToken != nil {
                self?.setpushToken(data: self!.pushToken!)
            }
            
            UserDefaults.standard.set(md.toJSONString(), forKey: user_saveKey)
            UserDefaults.standard.synchronize()
        }).disposed(by: rx.disposeBag)
    }
}


