//
//  LoginViewController.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/11/21.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
class LoginViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    @IBOutlet weak var mailTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    let viewModel = LoginViewModel.init()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailTextInput.rx.text.bind(to: viewModel.rx_email).disposed(by: rx.disposeBag)
        passwordTextInput.rx.text.bind(to: viewModel.rx_password).disposed(by: rx.disposeBag)

        viewModel.rx_step.asDriver()
            .drive(onNext: { [weak self] step in
                switch step {
                case .loading:
                    HUD.show(.progress)
                case .sucess:
                    HUD.hide()
                    self?.dismiss(animated: true)
                case .errorMessage(let mesg):
                    HUD.hide()
                    self?.showToast(message: mesg)
                case .failed:
                    HUD.hide()
                default:
                    break
                }
                
            }).disposed(by: rx.disposeBag)
        
        loginButton.rx.tap.subscribe({ [weak self]_ in
            self?.viewModel.onLogin()
        }).disposed(by: rx.disposeBag)

    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.mailTextInput {
            passwordTextInput.becomeFirstResponder()
        } else {
            self.viewModel.onLogin()
        }
        return true;
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registerSegue = R.segue.loginViewController.registerSegue(segue: segue) {
            registerSegue.destination.topViewController = self
        }
    }

}


