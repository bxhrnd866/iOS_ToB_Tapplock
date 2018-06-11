//
//  ConfirmPasswordController.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/5/21.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import UIKit

class ConfirmPasswordController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var mail: String!
    var password: String!
    var verCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let infro = R.segue.confirmPasswordController.showPersonalInfor(segue: segue) {
            infro.destination.mail = mail
            infro.destination.password = password
            infro.destination.verCode = verCode
        }
    }
    @IBAction func leftItemAction(_ sender: Any) {
        self.popToController(controller: LoginViewController.self)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        if isPasswordConfirm() {
           self.performSegue(withIdentifier: R.segue.confirmPasswordController.showPersonalInfor, sender: self)
        }
    }
    
    // 密码检查
    func isPasswordConfirm() -> Bool {
        if textField.text?.length == 0 {
            self.showToast(message: R.string.localizable.errorMessage_PasswordConfirmEmpty())
            return false
        } else if textField.text != password {
            self.showToast(message: R.string.localizable.errorMessage_PasswordConfirmWrong())
            return false
        }
        return true
    }
    deinit {
        plog("销毁了")
    }
}
