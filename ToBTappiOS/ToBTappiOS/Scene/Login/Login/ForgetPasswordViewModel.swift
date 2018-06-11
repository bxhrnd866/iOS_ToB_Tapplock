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
    var rx_confirmPassword: Variable<String?> = Variable(nil)
    var rx_resendVCodeTime: Variable<Int?> = Variable(nil)

    var vCodeMd5 = ""
    public var rx_errorMessage: Variable<String?> = Variable(nil)
    public var rx_upLoading: Variable<Bool> = Variable(false)
    public var rx_checkMailSuccess: Variable<Bool> = Variable(false)
    public var rx_setPasswordSuccess: Variable<Bool> = Variable(false)

    var canVCodeGoNext: Bool {
        get {
            if self.vCodeMd5 == self.rx_vCode.value?.md5() {
                self.rx_errorMessage.value = nil
                return true
            } else if self.rx_vCode.value == nil || self.rx_vCode.value!.length == 0 {
                self.rx_errorMessage.value = R.string.localizable.errorMessage_vCodeEmpty()
                return false
            } else {
                self.rx_errorMessage.value = R.string.localizable.errorMessage_vCodeWrong()
                return false
            }
        }
    }

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

            _ = provider.rx.request(ApiService.ForgetPasswordVerifyCode(mail: rx_mail.value!))
                    .mapObject(APIResponseString.self)
                    .subscribe(onSuccess: { [weak self] response in
                        if response.success {
                            self?.vCodeMd5 = response.data!
                        } else {
                            self?.rx_errorMessage.value = response.message
                        }
                    })
        }
    }

    func canSendVCodeAction() -> Bool {
        if rx_mail.value == nil || rx_mail.value?.length == 0 {
            rx_errorMessage.value = R.string.localizable.errorMessage_MailEmpty()
            return false
        } else if (rx_mail.value?.containsEmoji)! {
            self.rx_errorMessage.value = R.string.localizable.errorMessage_Emoji()
            return false
        } else if !rx_mail.value!.isMail {
            rx_errorMessage.value = R.string.localizable.errorMessage_MailIncorrect()
            return false
        } else if rx_resendVCodeTime.value != nil && rx_resendVCodeTime.value! > 0 {
            return false
        } else {
            return true
        }
    }

    func forgetPasswordNextAction() {
        if checkMail() {
            rx_upLoading.value = true
            _ = provider.rx.request(ApiService.CheckUser(mail: rx_mail.value!))
                    .mapObject(APIResponse<EmptyModel>.self)
                    .subscribe(onSuccess: { [weak self] response in
                        self?.rx_upLoading.value = false
                        if response.success {
                            self?.rx_errorMessage.value = nil
                            self?.rx_checkMailSuccess.value = true
                        } else {
                            self?.rx_errorMessage.value = response.message
                        }
                    })
        }
    }

    func checkMail() -> Bool {
        if rx_mail.value == nil || rx_mail.value?.count == 0 {
            rx_errorMessage.value = R.string.localizable.errorMessage_MailEmpty()
            return false
        } else if !rx_mail.value!.isMail {
            rx_errorMessage.value = R.string.localizable.errorMessage_MailIncorrect()
            return false
        } else {
            self.rx_errorMessage.value = nil
            return true
        }
    }

    func newPasswordOkAction() {
        if canSetNewPassword() {
            rx_upLoading.value = true
            _ = provider.rx.request(ApiService.ForgetPassword(mail: rx_mail.value!, newPassword: rx_password.value!, verifyCode: rx_vCode.value!))
                    .mapObject(APIResponse<EmptyModel>.self)
                    .subscribe(onSuccess: { [weak self] response in
                        self?.rx_upLoading.value = false
                        if response.success {
                            self?.rx_errorMessage.value = nil
                            self?.rx_setPasswordSuccess.value = true
                        } else {
                            self?.rx_errorMessage.value = response.message
                        }
                    })
        }
    }

    func canSetNewPassword() -> Bool {

        if rx_mail.value == nil || rx_mail.value?.length == 0 {
            rx_errorMessage.value = R.string.localizable.errorMessage_MailEmpty()
            return false
        } else if !rx_mail.value!.isMail {
            rx_errorMessage.value = R.string.localizable.errorMessage_MailIncorrect()
            return false
        } else if rx_password.value == nil || rx_password.value?.length == 0 {
            rx_errorMessage.value = R.string.localizable.errorMessage_PasswordEmpty()
            return false
        } else if rx_password.value!.passwordTooShort {
            rx_errorMessage.value = R.string.localizable.errorMessage_PasswordTooShort(passwordLenthMin)
            return false
        } else if rx_password.value!.passwordOverlength {
            rx_errorMessage.value = R.string.localizable.errorMessage_PasswordOverLenth(passwordLenthMax)
            return false
        } else if rx_confirmPassword.value == nil || rx_confirmPassword.value?.length == 0 {
            rx_errorMessage.value = R.string.localizable.errorMessage_PasswordConfirmEmpty()
            return false
        } else if rx_confirmPassword.value != rx_password.value {
            rx_errorMessage.value = R.string.localizable.errorMessage_PasswordConfirmWrong()
            return false
        } else if rx_vCode.value == nil || rx_vCode.value?.length == 0 {
            rx_errorMessage.value = R.string.localizable.errorMessage_vCodeEmpty()
            return false
        }
        else if rx_vCode.value != "???"{
            rx_errorMessage.value = R.string.localizable.errorMessage_vCodeWrong()
            return false
        }
        else {
            return true
        }

    }


}
