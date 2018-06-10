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
    
    @IBOutlet weak var labA: UILabel!
    @IBOutlet weak var labB: UILabel!
    @IBOutlet weak var labC: UILabel!
    @IBOutlet weak var labD: UILabel!
    @IBOutlet weak var labE: UILabel!
    @IBOutlet weak var labF: UILabel!
    
    @IBOutlet weak var textfield: UITextField!
    var code: String = ""
    var apiCode: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textfield.rx.text.asObservable().distinctUntilChanged().subscribe(onNext: { [weak self] text in
            
            self?.showCode(text: text ?? "")
        }).disposed(by: rx.disposeBag)
        
//        sendVCodeAction()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textfield.becomeFirstResponder()
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
        }
    }
    // 验证码
    func showCode(text: String) {
        let num = text.length
        if text.length == 0 {
            labA.text = ""
            labB.text = ""
            labC.text = ""
            labD.text = ""
            labE.text = ""
            labF.text = ""
            return
        }
        let str = text.inserting(separator: ",", every: 1)
        let arr = str.components(separatedBy: ",")

        Tapprint(arr)
        switch num {
        case 1:
            labA.text = arr[0]
            labB.text = ""
            labC.text = ""
            labD.text = ""
            labE.text = ""
            labF.text = ""
        case 2:
            labA.text = arr[0]
            labB.text = arr[1]
            labC.text = ""
            labD.text = ""
            labE.text = ""
            labF.text = ""
        case 3:
            labA.text = arr[0]
            labB.text = arr[1]
            labC.text = arr[2]
            labD.text = ""
            labE.text = ""
            labF.text = ""
        case 4:
            labA.text = arr[0]
            labB.text = arr[1]
            labC.text = arr[2]
            labD.text = arr[3]
            labE.text = ""
            labF.text = ""
        case 5:
            labA.text = arr[0]
            labB.text = arr[1]
            labC.text = arr[2]
            labD.text = arr[3]
            labE.text = arr[4]
            labF.text = ""
        case 6:
            labA.text = arr[0]
            labB.text = arr[1]
            labC.text = arr[2]
            labD.text = arr[3]
            labE.text = arr[4]
            labF.text = arr[5]
        default:
            break
        }
    }
    // 校验验证码
    func isCheckCode() -> Bool {
        
        if labA.text != nil {
            code += labA.text!
        } else if labB.text != nil {
            code += labB.text!
        } else if labC.text != nil {
            code += labC.text!
        } else if labD.text != nil {
            code += labD.text!
        } else if labE.text != nil {
            code += labE.text!
        } else if labF.text != nil {
            code += labF.text!
        }
        
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
        
        _ = provider.rx.request(ApiService.RegisterVerifyCode(mail: mail))
            .mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { response in
                if response.success {
                    Tapprint(response)
//                    self.rx_resendVCodeTime.value = 120
//                    let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
//                    codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
//                    codeTimer.setEventHandler(handler: {
//                        self.rx_resendVCodeTime.value = self.rx_resendVCodeTime.value! - 1
//                        if self.rx_resendVCodeTime.value! <= 0 {
//                            codeTimer.cancel()
//                        }
//                    })
//                    codeTimer.resume()
//                } else {
//                    self.rx_errorMessage.value = response.message
                }
            })
    }
    deinit {
        Tapprint("销毁了")
    }
}



