//
//  EditUserViewModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/8/1.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift
class EditUserViewModel: NSObject {
    
    var rx_step: Variable<RequestStep> = Variable(.none)
    var rx_oldPassword: Variable<String?> = Variable(nil)
    var rx_newPassword: Variable<String?> = Variable(nil)
    var rx_comfromPassword: Variable<String?> = Variable(nil)
    
    
    var rx_title: Variable<String?> = Variable("")
    var rx_description: Variable<String?> = Variable("")
    
    
    func changePasswordSaveButtonAction() {
        if canSetNewPassword() {
            self.rx_step.value = .loading
            provider.rx.request(APIServer.chagePassword(newPassword: rx_newPassword.value!, oldPassword: rx_oldPassword.value!))
                .mapObject(APIResponse<UserModel>.self)
                .subscribe(onSuccess: { [weak self] response in
                    if response.success {
                        self?.rx_step.value = .sucess
                    
                    } else {
                        self?.rx_step.value = RequestStep.errorMessage(mesg: response.codeMessage)
                    }
                }) { ( error) in
                    self.rx_step.value = .failed
                }.disposed(by: rx.disposeBag)
        }
    }
    
    func canSetNewPassword() -> Bool {
        
        if rx_oldPassword.value == nil || rx_oldPassword.value?.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_OldPasswordEmpty())
            return false
        } else if rx_newPassword.value == nil || rx_newPassword.value?.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_NewPasswordEmpty())
            return false
        } else if rx_newPassword.value!.passwordTooShort {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_NewPasswordTooShort(passwordLenthMin))
            return false
        } else if rx_newPassword.value!.passwordOverlength {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_NewPasswordOverLenth(passwordLenthMax))
            return false
        } else if (rx_newPassword.value?.containsEmoji)! {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_Emoji())
            return false
        } else if rx_comfromPassword.value == nil || rx_comfromPassword.value?.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_PasswordConfirmEmpty())
            return false
        } else if rx_comfromPassword.value != rx_newPassword.value {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_PasswordConfirmWrong())
            return false
        } else {
            return true
        }
    }
    
    
    func sendFeedBack() {
        if canSend() {
            self.rx_step.value = .loading
            provider.rx.request(APIServer.feedBack(content: rx_description.value!, title: rx_title.value!))
                .mapObject(APIResponse<EmptyModel>.self)
                .subscribe(onSuccess: { [weak self] response in
                    if response.success {
                        self?.rx_step.value = .sucess
                    } else {
                        self?.rx_step.value = RequestStep.errorMessage(mesg: response.codeMessage)
                    }
                }) { ( error) in
                    self.rx_step.value = .failed
                }.disposed(by: rx.disposeBag)
        }
        
    }
    
    func canSend() -> Bool {
        if rx_title.value == nil || rx_title.value!.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_FeedbackTitleEmpty())
            return false
        } else if (rx_title.value?.containsEmoji)! {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_Emoji())
            return false
        } else if rx_description.value == nil || rx_description.value!.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_FeedbackDescriptionEmpty())
            return false
        } else if (rx_description.value?.containsEmoji)! {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_Emoji())
            return false
        } else {
            return true
        }
    }
    
    
}
