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
    func setpushToken(){
        
        if pushToken == nil {
            return
        }
        plog("更新token")
        provider.rx.request(APIServer.userUpdate(fcmDeviceToken: pushToken,
                                                 firstName: nil,
                                                 groupIds: nil,
                                                 lastName: nil,
                                                 permissionIds: nil,
                                                 phone: nil,
                                                 photoUrl: nil,
                                                 sex: nil)).subscribe(onSuccess: { [weak self] response in
                                                    if response.statusCode == 200 {
                                                        self?.pushToken = nil
                                                    }
                                                    
                                                 }).disposed(by: rx.disposeBag)
        
    }
    
    func refreshToken() {
        if ConfigModel.default.user.value != nil {
            let refresh = UserDefaults.standard.object(forKey: key_refreshToken) as? String
            
            provider.rx.request(APIServer.oauthToken(grant_type: "refresh_token", refresh_token: refresh, access_token: nil))
                .mapObject(BasicTokenModel.self)
                .subscribe(onSuccess: { [weak self] response in
                    if response.error == nil {
                        UserDefaults.standard.set(response.access_token, forKey: key_basicToken)
                        UserDefaults.standard.set(response.refresh_token, forKey: key_refreshToken)
                        plog("设置成功")
                       
                    } else {
                        plog("失败 继续调用")
                        
                        self?.deleteToken(logout: true)
                        
                    }
                }).disposed(by: rx.disposeBag)
        }
    }
    
    
    func deleteToken(logout: Bool = false) {
        
        let usermanger = UserDefaults(suiteName: "group.tapplockNotificaitonService.com")
        let type = usermanger?.object(forKey: "NotificationType") as? String
    
        if type != nil || logout == true {
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            ConfigModel.default.user.value = nil
            DispatchQueue.main.async(execute: {
                delegate.removeMenuView()
                if let presnt = delegate.window?.rootViewController?.presentedViewController {
                    presnt.dismiss(animated: false) {
                        if let pt = delegate.window?.rootViewController?.presentedViewController {
                            pt.dismiss(animated: false, completion: nil)
                        }
                    }
                }
            })
            
            let access = UserDefaults.standard.object(forKey: key_basicToken) as? String
            provider.rx.request(APIServer.oauthToken(grant_type: nil , refresh_token: nil, access_token: access))
                .mapObject(APIResponse<EmptyModel>.self)
                .subscribe(onSuccess: { response in
                    
                    if response.success {
                        plog("删除token 成功")
                    }
                    
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
        
        let usermanger = UserDefaults(suiteName: "group.tapplockNotificaitonService.com")
        let userStr: String? = usermanger?.value(forKey: "user_saveKey") as? String
        if userStr != nil {
            if let user = UserModel(JSONString: userStr!) {
                self.user.value = user
            }
        }

        
        user.asObservable().subscribe(onNext: { [weak self] model in
            let usermanger = UserDefaults(suiteName: "group.tapplockNotificaitonService.com")
            guard let md = model else {
                usermanger?.removeObject(forKey: "user_saveKey")
                usermanger?.removeObject(forKey: "NotificationType")
                TapplockManager.default.reset()
                return
            }
            
            if self?.pushToken != nil {
                self?.setpushToken()
            }
            
            usermanger?.set(md.toJSONString(), forKey: "user_saveKey")
            
        }).disposed(by: rx.disposeBag)
    }
    
    
    
  
}


