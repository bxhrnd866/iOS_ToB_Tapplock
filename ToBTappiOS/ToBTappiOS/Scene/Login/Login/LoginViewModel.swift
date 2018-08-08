//
//  LoginViewModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/5.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import CryptoSwift
import Moya_ObjectMapper
import ObjectMapper
class LoginViewModel: NSObject {
    public var rx_email: Variable<String?> = Variable(nil)
    public var rx_password: Variable<String?> = Variable(nil)
    var rx_step: Variable<RequestStep> = Variable(.none)
    
    public func onLogin() {
        let password = rx_password.value
        let mail = rx_email.value
        if canLogin(password: password, mail: mail) {
            
            self.rx_step.value = RequestStep.loading
            provider.rx.request(APIServer.userLog(mail: mail!, password: password!))
                .mapObject(APIResponse<UserModel>.self)
                .subscribe(onSuccess: { [weak self] response in
                    
                    if response.success {
                        UserDefaults.standard.set(response.data?.accessToken, forKey: key_basicToken)
                        UserDefaults.standard.set(response.data?.refreshToken, forKey: key_refreshToken)

                        ConfigModel.default.user.value = response.data!
                        self?.rx_step.value = RequestStep.sucess
                        
                    } else {
                        self?.rx_step.value = RequestStep.errorMessage(mesg: response.codeMessage)
                    }
                
                }) { ( error) in
                    self.rx_step.value = .failed
                }.disposed(by: rx.disposeBag)
           
        }
    }

    //上传数据检查
    private func canLogin(password: String?, mail: String?) -> Bool {
        if rx_email.value == nil || rx_email.value?.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_MailEmpty())
            return false
        } else if (rx_email.value?.containsEmoji)! {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_Emoji())
            return false
        }
        else if rx_password.value == nil || rx_password.value?.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_PasswordEmpty())
            return false
        } else if (rx_password.value?.containsEmoji)! {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_Emoji())
            return false
        } else {
            return true
        }
    }

}
