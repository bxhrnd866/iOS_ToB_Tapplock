//
//  RegistMailController.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/5/21.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import UIKit

class RegistMailController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    @IBAction func mailNextAction(_ sender: Any) {
        
        if isMailCheck() {
            self.performSegue(withIdentifier: R.segue.registMailController.registerVerfication, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let verficaiton = R.segue.registMailController.registerVerfication(segue: segue) {
            verficaiton.destination.mail = textField.text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 是否是mail
    func isMailCheck() -> Bool {
        if textField.text?.length == 0 {
            self.showToast(message: R.string.localizable.errorMessage_MailEmpty())
            return false
        } else if (textField.text?.containsEmoji)! {
            self.showToast(message: R.string.localizable.errorMessage_Emoji())
            return false
        } else if !textField.text!.isMail {
            self.showToast(message: R.string.localizable.errorMessage_MailIncorrect())
            return false
        }
        
        return true
    }
    deinit {
        plog("销毁了")
        
        
    }
}
