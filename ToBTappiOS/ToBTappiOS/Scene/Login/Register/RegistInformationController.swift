//
//  RegistInformationController.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/5/21.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PKHUD
import Kingfisher

class RegistInformationController: UIViewController {

    @IBOutlet weak var header: UIImageView!
    
    @IBOutlet weak var firstField: UITextField!
    
    @IBOutlet weak var lastFeild: UITextField!
    
    @IBOutlet weak var btnTop: NSLayoutConstraint!
    
   
    var mail: String!
    var password: String!
    var verCode: String!
    
    let viewModel = RegisterViewModel.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isIphone5 {
            self.btnTop.constant = 10
        }
       
        firstField.rx.text.bind(to: viewModel.rx_firstName).disposed(by: rx.disposeBag)
        lastFeild.rx.text.bind(to: viewModel.rx_lastName).disposed(by: rx.disposeBag)
        viewModel.rx_mail.value = mail
        viewModel.rx_password.value = password
        viewModel.rx_vCode.value = verCode

        viewModel.rx_url.asDriver().filter {
            $0 != nil
            }.drive(onNext: { [weak self] urlString in
                if let url = URL(string: urlString!) {
                    self?.header.kf.setImage(with: ImageResource.init(downloadURL: url.httpURL), options: [.processor(kfProcessor)])
                }
            }).disposed(by: rx.disposeBag)
        

        
        //状态绑定
        viewModel.rx_errorMessage.asDriver()
            .filter {
                $0 != nil
            }
            .drive(onNext: { [weak self] (message) in
                self?.showToast(message: message!)
            })
            .disposed(by: rx.disposeBag)

        viewModel.rx_upLoading.asDriver()
            .drive(onNext: { uploading in
                (uploading ? HUD.show(.progress) : HUD.hide())
                
            })
            .disposed(by: rx.disposeBag)
        
        viewModel.rx_success.asDriver()
            .filter {
                $0
            }
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func leftItemAction(_ sender: Any) {
        self.popToController(controller: LoginViewController.self)
    }
    @IBAction func okAction(_ sender: Any) {
        self.viewModel.okButtonAction()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imagePicker = R.segue.registInformationController.imagePickerSegue(segue: segue) {
            imagePicker.destination.topViewController = self
            imagePicker.destination.uploader = RegisterUserImageUploader.init(callback: viewModel.setImageURL)
        }
    }
    deinit {
        Tapprint("销毁了")
    }
   
}
