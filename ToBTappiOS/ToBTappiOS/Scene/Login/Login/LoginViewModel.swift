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
import PKHUD
class LoginViewModel: NSObject {
    public var rx_email: Variable<String?> = Variable(nil)
    public var rx_password: Variable<String?> = Variable(nil)
    public var rx_user: Variable<UserModel?> = Variable(nil)
    public var rx_errorMessage: Variable<String?> = Variable(nil)

    public func onLogin() {
        let password = rx_password.value
        let mail = rx_email.value
        if canLogin(password: password, mail: mail) {
            

            HUD.show(.progress)
            provider.rx.request(APIServer.userLog(mail: mail!, password: password!))
                .mapObject(APIResponse<UserModel>.self)
                .subscribe(onSuccess: { [weak self] response in
                    HUD.hide()
                    if response.success {
                        ConfigModel.default.user.value = response.data!
                    } else {
                        self?.rx_errorMessage.value = response.codeMessage
                    }
                
                
            }).disposed(by: rx.disposeBag)
        }
    }

    //上传数据检查
    private func canLogin(password: String?, mail: String?) -> Bool {
        if rx_email.value == nil || rx_email.value?.length == 0 {
            rx_errorMessage.value = R.string.localizable.errorMessage_MailEmpty()
            return false
        } else if (rx_email.value?.containsEmoji)! {
            self.rx_errorMessage.value = R.string.localizable.errorMessage_Emoji()
            return false
        }
        else if rx_password.value == nil || rx_password.value?.length == 0 {
            rx_errorMessage.value = R.string.localizable.errorMessage_PasswordEmpty()
            return false
        } else if (rx_password.value?.containsEmoji)! {
            self.rx_errorMessage.value = R.string.localizable.errorMessage_Emoji()
            return false
        }
        else {
            return true
        }
    }
}
