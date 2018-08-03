//
//  ForgetPasswordViewModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/21.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import RxSwift

class ForgetPasswordViewModel: NSObject {
    var rx_mail: Variable<String?> = Variable(nil)
    var rx_vCode: Variable<String?> = Variable(nil)
    var rx_password: Variable<String?> = Variable(nil)
    var rx_resendVCodeTime: Variable<Int?> = Variable(nil)
    
    var rx_step: Variable<RequestStep> = Variable(.none)
    
    func sendVCodeAction() {
        if canSendVCodeAction() {
            self.rx_resendVCodeTime.value = 120
            let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
            codeTimer.setEventHandler(handler: { [weak self] in
                if self != nil {
                    self!.rx_resendVCodeTime.value = self!.rx_resendVCodeTime.value! - 1
                    if self!.rx_resendVCodeTime.value! <= 0 {
                        codeTimer.cancel()
                    }
                }
            })
            
            codeTimer.resume()
            provider.rx.request(APIServer.registerVerifyCode(mail: rx_mail.value!, type: 1))
                .mapObject(APIResponseString.self)
                .subscribe(onSuccess: { [weak self] response in
                    if response.success {
                        
                    } else {
                        self?.rx_step.value = RequestStep.errorMessage(mesg: response.codeMessage)
                    }
                }).disposed(by: rx.disposeBag)
        }
    }

    func canSendVCodeAction() -> Bool {
        if rx_mail.value == nil || rx_mail.value?.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_MailEmpty())
            return false
        } else if (rx_mail.value?.containsEmoji)! {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_Emoji())
            return false
        } else if !rx_mail.value!.isMail {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_MailIncorrect())
            return false
        } else if rx_resendVCodeTime.value != nil && rx_resendVCodeTime.value! > 0 {
            return false
        } else {
            return true
        }
    }


    func saveOkAction() {
        if canSetNewPassword() {
            rx_step.value = .loading
            provider.rx.request(APIServer.forgetPassword(mail: rx_mail.value!, newPassword: rx_password.value!, verifyCode: rx_vCode.value!))
                    .mapObject(APIResponse<EmptyModel>.self)
                    .subscribe(onSuccess: { [weak self] response in
                        
                        if response.success {
                            self?.rx_step.value = RequestStep.sucess
                        } else {
                            self?.rx_step.value = RequestStep.errorMessage(mesg: response.codeMessage)
                        }
                    }).disposed(by: rx.disposeBag)
        }
    }

    func canSetNewPassword() -> Bool {

        if rx_mail.value == nil || rx_mail.value?.length == 0 {

            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_MailEmpty())
            return false
        } else if !rx_mail.value!.isMail {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_MailIncorrect())
            return false
        } else if rx_password.value == nil || rx_password.value?.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_PasswordEmpty())
            return false
        } else if rx_password.value!.passwordTooShort {
          
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_PasswordTooShort(passwordLenthMin))
            return false
        } else if rx_password.value!.passwordOverlength {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_PasswordOverLenth(passwordLenthMax))
            return false
        } else if rx_vCode.value == nil || rx_vCode.value?.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_vCodeEmpty())
            return false
        } else if rx_vCode.value == "???"{
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_vCodeWrong())
            return false
        }
        else {
            return true
        }

    }


}
