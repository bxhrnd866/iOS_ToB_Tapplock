//
//  VerificationCodeViewController.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/11/22.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import PKHUD

class VerificationCodeViewController: UIViewController {
    var viewModel: ForgetPasswordViewModel?
    @IBOutlet weak var nextButton: normalGradientBtn!
    @IBOutlet weak var sendVCodeButton: UIButton!
    @IBOutlet weak var vCodeTextInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        vCodeTextInput.rx.text.bind(to: viewModel!.rx_vCode).disposed(by: rx.disposeBag)

        viewModel?.rx_errorMessage.asDriver()
                .filter {
                    $0 != nil
                }
                .drive(onNext: { [weak self] (message) in
                    self?.showToast(message: message!)
                })
                .disposed(by: rx.disposeBag)

        viewModel?.rx_upLoading.asDriver()
                .drive(onNext: { uploading in
                    (uploading ? HUD.show(.progress) : HUD.hide())
                })
                .disposed(by: rx.disposeBag)

        sendVCodeButton.rx.tap.subscribe({ [weak self] _ in
            self?.viewModel?.sendVCodeAction()
        }).disposed(by: rx.disposeBag)

        viewModel?.rx_resendVCodeTime.asDriver().filter {
            $0 != nil
        }.drive(onNext: { [weak self]  time in
            if time! > 0 {
                self?.sendVCodeButton.setTitle(R.string.localizable.resendCount(time!), for: .normal)
            } else {
                self?.sendVCodeButton.setTitle(R.string.localizable.resend(), for: .normal)
            }
        }).disposed(by: rx.disposeBag)

        nextButton.rx.tap.subscribe({ [weak self] _ in
            if self != nil && self!.viewModel!.canVCodeGoNext {
                self?.performSegue(withIdentifier: R.segue.verificationCodeViewController.newPasswordSegue, sender: self)
            }
        }).disposed(by: rx.disposeBag)

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newPasswordSegue = R.segue.verificationCodeViewController.newPasswordSegue(segue: segue) {
            newPasswordSegue.destination.viewModel = viewModel
        }
    }

}
