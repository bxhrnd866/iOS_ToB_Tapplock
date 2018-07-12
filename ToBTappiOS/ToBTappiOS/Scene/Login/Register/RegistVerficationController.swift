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

class RegistVerficationController: UIViewController {

    var mail: String!
    var inviteCode: String!
    
    @IBOutlet weak var textA: UITextView!
    
    @IBOutlet weak var textB: UITextView!
    
    @IBOutlet weak var textC: UITextView!

    @IBOutlet weak var textD: UITextView!
    
    @IBOutlet weak var textE: UITextView!

    @IBOutlet weak var TextF: UITextView!
    
    @IBOutlet weak var resendTime: UILabel!
    var rx_resendVCodeTime: Variable<Int> = Variable(120)
    
    var code: String = ""
    var apiCode: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx_resendVCodeTime.asObservable().subscribe(onNext: { [weak self] num in
            self?.resendTime.text = "Resend after " + "\(num)" + "s"
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
        self.performSegue(withIdentifier: R.segue.registVerficationController.showPassword, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let confirm = R.segue.registVerficationController.showPassword(segue: segue) {
            confirm.destination.mail = mail
            confirm.destination.verCode = code
            confirm.destination.inviteCode = inviteCode
        }
    }
//    // 验证码
//    func showCode(text: String) {
//        let num = text.length
//        if text.length == 0 {
//            labA.text = ""
//            labB.text = ""
//            labC.text = ""
//            labD.text = ""
//            labE.text = ""
//            labF.text = ""
//            return
//        }
//        let str = text.inserting(separator: ",", every: 1)
//        let arr = str.components(separatedBy: ",")
//
//        switch num {
//        case 1:
//            labA.text = arr[0]
//            labB.text = ""
//            labC.text = ""
//            labD.text = ""
//            labE.text = ""
//            labF.text = ""
//        case 2:
//            labA.text = arr[0]
//            labB.text = arr[1]
//            labC.text = ""
//            labD.text = ""
//            labE.text = ""
//            labF.text = ""
//        case 3:
//            labA.text = arr[0]
//            labB.text = arr[1]
//            labC.text = arr[2]
//            labD.text = ""
//            labE.text = ""
//            labF.text = ""
//        case 4:
//            labA.text = arr[0]
//            labB.text = arr[1]
//            labC.text = arr[2]
//            labD.text = arr[3]
//            labE.text = ""
//            labF.text = ""
//        case 5:
//            labA.text = arr[0]
//            labB.text = arr[1]
//            labC.text = arr[2]
//            labD.text = arr[3]
//            labE.text = arr[4]
//            labF.text = ""
//        case 6:
//            labA.text = arr[0]
//            labB.text = arr[1]
//            labC.text = arr[2]
//            labD.text = arr[3]
//            labE.text = arr[4]
//            labF.text = arr[5]
//        default:
//            break
//        }
//    }
    // 校验验证码
    func isCheckCode() -> Bool {
        
//        if labA.text != nil {
//            code += labA.text!
//        } else if labB.text != nil {
//            code += labB.text!
//        } else if labC.text != nil {
//            code += labC.text!
//        } else if labD.text != nil {
//            code += labD.text!
//        } else if labE.text != nil {
//            code += labE.text!
//        } else if labF.text != nil {
//            code += labF.text!
//        }
        
        if code.length == 0 || code.length != 6 {
            self.showToast(message: R.string.localizable.errorMessage_vCodeEmpty())
            return false
        } else if code.containsEmoji {
            self.showToast(message: R.string.localizable.errorMessage_Emoji())
            return false
        } else if code != apiCode {
            return false
        }
        return true
    }

    func sendVCodeAction() {
        
//        _ = provider.rx.request(APIServer.registerVerifyCode(mail: mail, type: 0))
//            .mapObject(APIResponse<EmptyModel>.self)
//            .subscribe(onSuccess: { response in
//                if response.success {
//                    
//                    self.rx_resendVCodeTime.value = 120
//                    let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
//                    codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
//                    codeTimer.setEventHandler(handler: {
//                        self.rx_resendVCodeTime.value = self.rx_resendVCodeTime.value - 1
//                        if self.rx_resendVCodeTime.value <= 0 {
//                            self.rx_resendVCodeTime.value = 120
//                            codeTimer.cancel()
//                        }
//                    })
//                    codeTimer.resume()
//                } else {
//                    
//                }
//            })
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
            self.textE.becomeFirstResponder()
        }
        if self.textE.text.length == 1 {
            self.TextF.becomeFirstResponder()
        }
        if self.TextF.text.length == 1 {
            self.TextF.resignFirstResponder()
        }
    }
}



