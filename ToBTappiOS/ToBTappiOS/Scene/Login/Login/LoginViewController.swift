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
//import Reachability

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

        if (self.navigationController != nil) {
            self.navigationController!.interactivePopGestureRecognizer!.delegate = self;
        }
        self.bindingData()
        self.bindingAction()

//        //监视网络状态
//        let reachability = Reachability()!
//        reachability.whenUnreachable = { _ in
//            self.showToast(message: R.string.localizable.errorMessage_NetOff())
//        }
//
//        do {
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }

    }

    //绑定页面状态
    func bindingData() {
        
        mailTextInput.rx.text.bind(to: viewModel.rx_email).disposed(by: rx.disposeBag)
        passwordTextInput.rx.text.bind(to: viewModel.rx_password).disposed(by: rx.disposeBag)

        _ = ConfigModel.default.user.asDriver()
                .throttle(1, latest: true)
                .filter {
                    $0 != nil
                }
                .drive(onNext: { token in
                    self.dismiss(animated: true)
                })
                .disposed(by: rx.disposeBag)

        viewModel.rx_errorMessage.asObservable()
                .filter {
                    $0 != nil
                }
                .subscribe(onNext: { [weak self] (message) in
                    self?.showToast(message: message!)
                })
                .disposed(by: rx.disposeBag)
    }
    
    //绑定页面动作
    func bindingAction() {
        loginButton.rx.tap.subscribe({ [weak self]_ in
            self?.viewModel.onLogin()
        }).disposed(by: rx.disposeBag)

    }

    //重新加入导航栏手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        if self.navigationController?.viewControllers.count == 1 {
            return false;
        }
        return true;
    }

    //密码输入框点击回车进行登录动作
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


