//
//  RegistVerficationController.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/5/21.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
class RegistVerficationController: UIViewController {

    var mail: String!
 
    
    @IBOutlet weak var textA: UITextView!
    
    @IBOutlet weak var textB: UITextView!
    
    @IBOutlet weak var textC: UITextView!

    @IBOutlet weak var textD: UITextView!
    
    @IBOutlet weak var resendBtn: UIButton!
    
    var rx_resendVCodeTime: Variable<Int> = Variable(0)
    
    var code: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         rx_resendVCodeTime.asDriver().drive(onNext: { [weak self] time in
            if time > 0 {
                self?.resendBtn.setTitle(R.string.localizable.resendCount(time), for: .normal)
                
                } else {
                    self?.resendBtn.setTitle(R.string.localizable.resend(), for: .normal)
                }
            }).disposed(by: rx.disposeBag)
        
        sendVCodeAction()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftItemAction(_ sender: Any) {
        self.popToController(controller: LoginViewController.self)
    }
    @IBAction func nextAction(_ sender: Any) {
        
        if isCheckCode() {
            HUD.show(.progress)
            provider.rx.request(APIServer.checkVerifyCode(mail: mail, verifyCode: code))
                .mapObject(APIResponse<EmptyModel>.self)
                .subscribe(onSuccess: { [weak self] response in
                    HUD.hide()
                    if response.success {
                        
                        self?.performSegue(withIdentifier: R.segue.registVerficationController.showInviationCode, sender: self)
                    } else {
                        self?.showToast(message: response.codeMessage)
                    }
                    
                }).disposed(by: rx.disposeBag)
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let confirm = R.segue.registVerficationController.showInviationCode(segue: segue) {
            confirm.destination.mail = mail
        }
    }

    // 校验验证码
    func isCheckCode() -> Bool {
        code = textA.text + textB.text + textC.text + textD.text
        plog(code)
        if code.length == 0 || code.length != 4 {
            self.showToast(message: R.string.localizable.errorMessage_vCodeEmpty())
            return false
        } else if code.containsEmoji {
            self.showToast(message: R.string.localizable.errorMessage_Emoji())
            return false
        }
        return true
    }

    //数据检查
    func canSendVCodeAction() -> Bool {
        if mail.length == 0 {
            self.showToast(message: R.string.localizable.errorMessage_MailEmpty())
            return false
        } else if rx_resendVCodeTime.value > 0 {
            return false
        } else {
            return true
        }
    }
    
    func sendVCodeAction() {
        if canSendVCodeAction() {
            
            provider.rx.request(APIServer.registerVerifyCode(mail: mail, type: 0)).mapObject(APIResponse<EmptyModel>.self).subscribe(onSuccess: { response in
                if response.success {
                    
                    self.rx_resendVCodeTime.value = 120
                    let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
                    codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
                    codeTimer.setEventHandler(handler: {
                        self.rx_resendVCodeTime.value = self.rx_resendVCodeTime.value - 1
                        if self.rx_resendVCodeTime.value <= 0 {
                            codeTimer.cancel()
                        }
                    })
                    codeTimer.resume()
                } else {
                    
                }
            }).disposed(by: rx.disposeBag)
        }
    }
    
    
    deinit {
        plog("销毁了")
    }
}

extension RegistVerficationController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.length > 1 {
            textView.text = String(textView.text.first!)
        }
        if self.textA.text.length == 1 {
            self.textB.becomeFirstResponder()
        }
        if self.textB.text.length == 1 {
            self.textC.becomeFirstResponder()
        }
        if self.textC.text.length == 1 {
            self.textD.becomeFirstResponder()
        }
        if self.textD.text.length == 1 {
            self.textD.resignFirstResponder()
        }
    }
}



