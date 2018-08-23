//
//  RegisterViewModel.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/21.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import RxSwift

class RegisterViewModel: NSObject {
    var rx_url: Variable<String?> = Variable("https://res.cloudinary.com/tapplock/image/upload/v1534414207/tapplock-b2b-android/1.png")
    var rx_firstName: Variable<String?> = Variable(nil)
    var rx_lastName: Variable<String?> = Variable(nil)
    var rx_mail: Variable<String?> = Variable(nil)
    var rx_password: Variable<String?> = Variable(nil)
    var rx_inviteCode: Variable<String?> = Variable(nil)
    var rx_iphone: Variable<String?> = Variable(nil)
    var rx_sex: Variable<Int> = Variable(0)
    var rx_corpId: Variable<Int?> = Variable(nil)

    
    var rx_step: Variable<RequestStep> = Variable(.none)

    func setImageURL(_ url: String) {
        rx_url.value = url
    }

    func okButtonAction() {
        if canRegist() {
            rx_step.value = .loading

            provider.rx.request(APIServer.userRegister(corpId: rx_corpId.value!,
                                                       fcmDeviceToken: nil,
                                                       inviteCode: rx_inviteCode.value!,
                                                       firstName: rx_firstName.value!,
                                                       lastName: rx_lastName.value!,
                                                       mail: rx_mail.value!,
                                                       password: rx_password.value!,
                                                       phone: rx_iphone.value!,
                                                       photoUrl: rx_url.value,
                                                       sex: rx_sex.value))
                .mapObject(APIResponse<EmptyModel>.self).subscribe(onSuccess: { [weak self] response in
                    if response.success {
                        self?.rx_step.value = RequestStep.sucess
                    } else {
                        if response.codeMessage != nil {
                            self?.rx_step.value = RequestStep.errorMessage(mesg: response.codeMessage!)
                        }  else {
                            self?.rx_step.value = .failed
                        }
                    }
                }){ ( error) in
                    self.rx_step.value = .failed
                }.disposed(by: rx.disposeBag)
        }
    }
    
    //数据检查
    func canRegist() -> Bool {
        if rx_firstName.value == nil || rx_firstName.value?.length == 0 {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_FirstNameEmpty())
            return false
        } else if (rx_firstName.value?.containsEmoji)! {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_Emoji())
            return false
        } else if rx_firstName.value!.nameOverlength {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_FirstNameOverLenth(nameLenthMax))
            return false
        } else if rx_lastName.value == nil || rx_lastName.value?.length == 0 {

            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_LastNameEmpty())
            return false
        } else if (rx_lastName.value?.containsEmoji)! {
            
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_Emoji())
            return false
        } else if rx_lastName.value!.nameOverlength {
            
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.errorMessage_LastNameOverLenth(nameLenthMax))
            return false
        } else if rx_iphone.value?.isPurnInt == false {
            rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.enterthenumber())
            return false
        } else if rx_iphone.value != nil {
            if (rx_iphone.value?.length)! > 11 {
                rx_step.value = RequestStep.errorMessage(mesg: R.string.localizable.phoneNumberLong())
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
}
