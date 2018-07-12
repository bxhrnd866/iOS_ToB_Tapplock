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
//        inviteCodeCheck()
        self.performSegue(withIdentifier: R.segue.inviteCodeController.showVerificaitonCode, sender: self)
    }
    
    func inviteCodeCheck() {
        HUD.show(.progress)
        provider.rx.request(APIServer.checkinviteCodes(inviteCode: textField.text!)).mapObject(APIResponse<EmptyModel>.self).subscribe(onSuccess: { [weak self] (response) in
            HUD.hide()
            if response.success {
                self?.performSegue(withIdentifier: R.segue.inviteCodeController.showVerificaitonCode, sender: self)
            } else {
                self?.showToast(message: "fasfasfsadfasfsa")
            }
        }).disposed(by: rx.disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = R.segue.inviteCodeController.showVerificaitonCode(segue: segue) {
            vc.destination.mail = mail
            vc.destination.inviteCode = textField.text
        }
    }
    

}
