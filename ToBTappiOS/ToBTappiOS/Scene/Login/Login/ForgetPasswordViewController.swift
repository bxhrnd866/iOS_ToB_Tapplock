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

    override func viewDidLoad() {
        super.viewDidLoad()
        mailTextInput.rx.text.bind(to: viewModel.rx_mail).disposed(by: rx.disposeBag)

        viewModel.rx_errorMessage.asDriver()
                .filter {
                    $0 != nil
                }
                .drive(onNext: { [weak self](message) in
                    self?.showToast(message: message!)
                })
                .disposed(by: rx.disposeBag)

        _ = viewModel.rx_checkMailSuccess.asDriver()
                .asDriver()
                .filter {
                    $0
                }
                .drive(onNext: { [weak self] _ in
                    self?.performSegue(withIdentifier: R.segue.forgetPasswordViewController.verificationCodeSegue, sender: self)
                })
                .disposed(by: rx.disposeBag)

        viewModel.rx_upLoading.asDriver()
                .drive(onNext: { uploading in
                    (uploading ? HUD.show(.progress) : HUD.hide())
                })
                .disposed(by: rx.disposeBag)

        nextButton.rx.tap.subscribe({ [weak self] _ in
            self?.viewModel.forgetPasswordNextAction()
        }).disposed(by: rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    @IBAction override func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vCodeSegue = R.segue.forgetPasswordViewController.verificationCodeSegue(segue: segue) {
            vCodeSegue.destination.viewModel = viewModel
        }
    }

}
