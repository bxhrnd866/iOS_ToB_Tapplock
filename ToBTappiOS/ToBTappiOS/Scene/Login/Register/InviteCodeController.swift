//
//  InviteCodeController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/11.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import PKHUD
class InviteCodeController: UIViewController {

    var mail: String!
    var corpId: Int?
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextAction(_ sender: Any) {
        HUD.show(.progress)
        if textField.text?.length == 0 {
            return
        }
        
        provider.rx.request(APIServer.checkinviteCodes(inviteCode: textField.text!))
            .mapObject(APIResponse<InviteCodeModel>.self)
            .subscribe(onSuccess: { [weak self] (response) in
                
                HUD.hide()
                if response.success {
                    self?.corpId = response.data?.corpId
                    self?.performSegue(withIdentifier: R.segue.inviteCodeController.showPassword, sender: self)
                } else {
                    if response.codeMessage != nil  {
                        self?.showToast(message: response.codeMessage!)
                    }
                    
                }
            }){ ( error) in
                HUD.hide()
            }.disposed(by: rx.disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = R.segue.inviteCodeController.showPassword(segue: segue) {
            vc.destination.mail = mail
            vc.destination.inviteCode = textField.text
            vc.destination.corpId = corpId
        }
    }
    
    @IBAction func leftBtnItemSelect(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    deinit {
        plog("销毁了")
        
    }
}
extension InviteCodeController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " {
            return false
        }
        return true
    }
}
