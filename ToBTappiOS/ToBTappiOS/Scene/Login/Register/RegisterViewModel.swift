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
    var rx_url: Variable<String?> = Variable("")
    var rx_firstName: Variable<String?> = Variable(nil)
    var rx_lastName: Variable<String?> = Variable(nil)
    var rx_mail: Variable<String?> = Variable(nil)
    var rx_vCode: Variable<String?> = Variable(nil)
    var rx_password: Variable<String?> = Variable(nil)
    var rx_resendVCodeTime: Variable<Int?> = Variable(nil)
    
    
    public var rx_errorMessage: Variable<String?> = Variable(nil)
    public var rx_success: Variable<Bool> = Variable(false)
    public var rx_upLoading: Variable<Bool> = Variable(false)


    func setImageURL(_ url: String) {
        rx_url.value = url
    }

    func okButtonAction() {
        if canRegist() {
            rx_upLoading.value = true
            _ = provider.rx.request(ApiService.Register(firstName: rx_firstName.value!, lastName: rx_lastName.value!, mail: rx_mail.value!, imageURL: rx_url.value!, password: rx_password.value!, vCode: rx_vCode.value!))
                    .mapObject(APIResponse<EmptyModel>.self)
                    .subscribe(onSuccess: { [weak self] response in
                        
                       
                        self?.rx_upLoading.value = false
                        if response.success {
                            self?.rx_success.value = true
                        } else {
                            self?.rx_errorMessage.value = response.message
                        }
                    })
        }
    }
    
    //数据检查
    func canRegist() -> Bool {
        if rx_firstName.value == nil || rx_firstName.value?.length == 0 {
            rx_errorMessage.value = R.string.localizable.errorMessage_FirstNameEmpty()
            return false
        } else if (rx_firstName.value?.containsEmoji)! {
            self.rx_errorMessage.value = R.string.localizable.errorMessage_Emoji()
            return false
        } else if rx_firstName.value!.nameOverlength {
            rx_errorMessage.value = R.string.localizable.errorMessage_FirstNameOverLenth(nameLenthMax)
            return false
        } else if rx_lastName.value == nil || rx_lastName.value?.length == 0 {
            rx_errorMessage.value = R.string.localizable.errorMessage_LastNameEmpty()
            return false
        } else if (rx_lastName.value?.containsEmoji)! {
            self.rx_errorMessage.value = R.string.localizable.errorMessage_Emoji()
            return false
        } else if rx_lastName.value!.nameOverlength {
            rx_errorMessage.value = R.string.localizable.errorMessage_LastNameOverLenth(nameLenthMax)
            return false
        } else {
            return true
        }
    }
}
