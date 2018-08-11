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
    var inviteCode: String!
    var corpId: Int!
    
    @IBOutlet weak var confirmTextfield: UITextField!
    
    
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
            self.performSegue(withIdentifier: R.segue.registerPasswordController.showPersonalInformation, sender: self)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let vc = R.segue.registerPasswordController.showPersonalInformation(segue: segue) {
            vc.destination.mail = mail
            vc.destination.password = textField.text
            vc.destination.inviteCode = inviteCode
            vc.destination.corpId = corpId
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
        } else if textField.text != confirmTextfield.text {
            self.showToast(message: R.string.localizable.errorMessage_PasswordConfirmWrong())
            return false
        }
        return true
    }
    deinit {
        plog("销毁了")
    }

}
extension RegisterPasswordController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " {
            return false
        }
        return true
    }
}
