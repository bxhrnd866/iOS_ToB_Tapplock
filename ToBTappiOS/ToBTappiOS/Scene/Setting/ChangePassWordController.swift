//
//  ChangePassWordController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/6.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import PKHUD
class ChangePassWordController: UIViewController {

    @IBOutlet weak var oldPassword: UITextField!
    
    @IBOutlet weak var newpassword: UITextField!
    
    @IBOutlet weak var confirmpassword: UITextField!
    
    @IBOutlet weak var saveBtn: normalGradientBtn!
    let viewModel = EditUserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmpassword.rx.text.bind(to: viewModel.rx_comfromPassword).disposed(by: rx.disposeBag)
        newpassword.rx.text.bind(to: viewModel.rx_newPassword).disposed(by: rx.disposeBag)
        oldPassword.rx.text.bind(to: viewModel.rx_oldPassword).disposed(by: rx.disposeBag)
        
        saveBtn.rx.tap.subscribe({ [weak self] _ in
            self?.viewModel.changePasswordSaveButtonAction()
        }).disposed(by: rx.disposeBag)
        
        viewModel.rx_step.asDriver().drive(onNext: { [weak self] step in
            
            switch step {
            case .loading:
                HUD.show(.progress)
            case .sucess:
                HUD.hide()
                self?.showToast(message: R.string.localizable.successMessage_Password(),
                               didDismiss: { _ in
                                self?.navigationController?.popViewController(animated: true)
                })
            case .errorMessage(let mesg):
                 HUD.hide()
                self?.showToast(message: mesg)
            case .failed:
                HUD.hide()
            default:
                break
            }
            
            
        }).disposed(by: rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        plog("销毁了")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
