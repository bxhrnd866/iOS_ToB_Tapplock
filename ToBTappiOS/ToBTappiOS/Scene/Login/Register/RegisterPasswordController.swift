//
//  RegisterPasswordController.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/5/21.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import UIKit

class RegisterPasswordController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var mail: String!
    var verCode: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftItemAction(_ sender: Any) {
        self.popToController(controller: LoginViewController.self)
    }
    @IBAction func nextAction(_ sender: Any) {
        if isPasswordCheck() {
            self.performSegue(withIdentifier: R.segue.registerPasswordController.showConfirmPassword, sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let confirm = R.segue.registerPasswordController.showConfirmPassword(segue: segue) {
            confirm.destination.mail = mail
            confirm.destination.password = textField.text!
        }
    }
    
    // 密码检查
    func isPasswordCheck() -> Bool {
        if textField.text?.length == 0 {
            self.showToast(message: R.string.localizable.errorMessage_PasswordEmpty())
            return false
        } else if (textField.text?.containsEmoji)! {
            self.showToast(message: R.string.localizable.errorMessage_Emoji())
            return false
        } else if textField.text!.passwordTooShort {
            self.showToast(message: R.string.localizable.errorMessage_PasswordTooShort(passwordLenthMin))
            return false
        } else if textField.text!.passwordOverlength {
            self.showToast(message: R.string.localizable.errorMessage_PasswordOverLenth(passwordLenthMax))
            return false
        }
        
        return true
    }
    deinit {
        Tapprint("销毁了")
    }

}
