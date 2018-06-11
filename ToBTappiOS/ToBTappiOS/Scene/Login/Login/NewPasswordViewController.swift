//
//  NewPasswordViewController.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/11/22.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import PKHUD

class NewPasswordViewController: UIViewController {
    var viewModel: ForgetPasswordViewModel?
    @IBOutlet weak var passwordTextInput: UITextField!
    @IBOutlet weak var confirmPasswordTextInput: UITextField!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextInput.rx.text.bind(to: viewModel!.rx_password).disposed(by: rx.disposeBag)
        confirmPasswordTextInput.rx.text.bind(to: viewModel!.rx_confirmPassword).disposed(by: rx.disposeBag)

        okButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel!.newPasswordOkAction()
        }).disposed(by: rx.disposeBag)

        viewModel!.rx_errorMessage.asDriver()
                .filter {
                    $0 != nil
                }
                .drive(onNext: { [weak self] (message) in
                    self?.showToast(message: message!)
                })
                .disposed(by: rx.disposeBag)

        viewModel!.rx_upLoading.asDriver()
                .drive(onNext: { uploading in
                    (uploading ? HUD.show(.progress) : HUD.hide())
                })
                .disposed(by: rx.disposeBag)

        viewModel!.rx_setPasswordSuccess.asDriver()
                .filter {
                    $0
                }
                .drive(onNext: { [weak self] _ in
                    self?.navigationController?.popToRootViewController(animated: true)
                })
                .disposed(by: rx.disposeBag)
    }


}
