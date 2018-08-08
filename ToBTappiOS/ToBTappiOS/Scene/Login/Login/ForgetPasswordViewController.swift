//
//  ForgetPasswordViewController.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/11/21.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import PKHUD

class ForgetPasswordViewController: UIViewController {

    let viewModel = ForgetPasswordViewModel.init()
    @IBOutlet weak var mailTextInput: UITextField!
    @IBOutlet weak var nextButton: normalGradientBtn!

    @IBOutlet weak var codeText: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var sendCode: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailTextInput.rx.text.bind(to: viewModel.rx_mail).disposed(by: rx.disposeBag)
        password.rx.text.bind(to: viewModel.rx_password).disposed(by: rx.disposeBag)
        codeText.rx.text.bind(to: viewModel.rx_vCode).disposed(by: rx.disposeBag)
        
        
        viewModel.rx_step.asDriver()
            .drive(onNext: { [weak self] step in
                switch step {
                case .loading:
                    HUD.show(.progress)
                case .sucess:
                    HUD.hide()
                    self?.navigationController?.popViewController(animated: true)
                case .errorMessage(let mesg):
                    HUD.hide()
                    self?.showToast(message: mesg)
                case .failed:
                    HUD.hide()
                default:
                    break
                }
            
        }).disposed(by: rx.disposeBag)

        
        viewModel.rx_resendVCodeTime.asDriver().filter {
            $0 != nil
            }.drive(onNext: { [weak self]  time in
                if time! > 0 {
                    self?.sendCode.setTitle(R.string.localizable.resendCount(time!), for: .normal)
                } else {
                    self?.sendCode.setTitle(R.string.localizable.resend(), for: .normal)
                }
            }).disposed(by: rx.disposeBag)


        nextButton.rx.tap.subscribe({ [weak self] _ in
            self?.viewModel.saveOkAction()
        }).disposed(by: rx.disposeBag)
        
        
        sendCode.rx.tap.subscribe({ [weak self] _ in
            self?.viewModel.sendVCodeAction()
        }).disposed(by: rx.disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    @IBAction override func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}
