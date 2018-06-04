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
    
    // 用户模型
    var user: BehaviorRelay<UserModel?> = BehaviorRelay(value: nil)
    
    var language: Language!
    //推送Token
    var pushToken: String?
    
    static let `default` = ConfigModel()
    
    
    //Set推送Token
    func setpushToken(data: String) {
        pushToken = data
        if (pushToken != nil && user.value != nil) {
            _ = provider.rx.request(ApiService.EditUserConfiguration(mai: (user.value!.mail)!, deviceToken: pushToken, firstName: nil, lastName: nil, imageURL: nil, push: nil, showBattery: nil))
                .mapObject(APIResponse<UserModel>.self)
                .subscribe(onSuccess: { response in
                    plog(response)
                })
        }
    }
    
    private override init() {
        //设置语言
        super.init()
        let myLanguage: String? = UserDefaults.standard.object(forKey: language_model_key) as? String

        if myLanguage != nil && myLanguage! != "" {
            language = Language.init(myLanguage!)
        } else {
            let preferredLang = (UserDefaults.standard.object(forKey: language_model_key) as! Array<String>).first
            
            language = Language.init(preferredLang!)
        }

        
        //设置用户
        let userStr: String? = UserDefaults.standard.value(forKey: user_saveKey) as? String
        if userStr != nil {
            if let user = UserModel(JSONString: userStr!) {
                self.user.accept(user)
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

