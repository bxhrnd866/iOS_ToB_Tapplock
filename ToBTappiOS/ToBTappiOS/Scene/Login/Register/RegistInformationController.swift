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

class RegistInformationController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var header: UIImageView!
    
    @IBOutlet weak var firstField: UITextField!
    
    @IBOutlet weak var lastFeild: UITextField!
    
    @IBOutlet weak var phoneFeild: UITextField!
    
    @IBOutlet weak var sexlab: UILabel!
    
    @IBOutlet weak var sexBtn: UIButton!
    
    @IBOutlet weak var sexLab: UILabel!
    
    var mail: String!
    var password: String!
    var inviteCode: String!
    var corpId: Int!
    
    let viewModel = RegisterViewModel.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        firstField.rx.text.bind(to: viewModel.rx_firstName).disposed(by: rx.disposeBag)
        lastFeild.rx.text.bind(to: viewModel.rx_lastName).disposed(by: rx.disposeBag)
        phoneFeild.rx.text.bind(to: viewModel.rx_iphone).disposed(by: rx.disposeBag)
        
        viewModel.rx_mail.value = mail
        viewModel.rx_password.value = password
        viewModel.rx_inviteCode.value = inviteCode
        viewModel.rx_corpId.value = corpId
        
        viewModel.rx_url.asDriver().filter {
            $0 != nil
            }.drive(onNext: { [weak self] urlString in
                if let url = URL(string: urlString!) {
                    self?.header.kf.setImage(with: ImageResource.init(downloadURL: url), options: [.processor(kfProcessor)])
                }
            }).disposed(by: rx.disposeBag)
        

        viewModel.rx_step.asDriver()
            .drive(onNext: { [weak self] step in
                switch step {
                case .loading:
                    HUD.show(.progress)
                case .sucess:
                    HUD.hide()
                    self?.navigationController?.popToRootViewController(animated: true)
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
    @IBAction func headerBtnSelect(_ sender: Any) {
        
        //设置头像
    }
    
    @IBAction func leftItemAction(_ sender: Any) {
        self.popToController(controller: LoginViewController.self)
    }
    @IBAction func okAction(_ sender: Any) {
        self.viewModel.okButtonAction()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imagePicker = R.segue.registInformationController.showImagePickerIdentifier(segue: segue) {
            imagePicker.destination.topViewController = self
            imagePicker.destination.uploader = RegisterUserImageUploader.init(callback: viewModel.setImageURL)
        }
        
        if let sexvc = R.segue.registInformationController.showSexSelect(segue: segue) {
            sexvc.destination.preferredContentSize = CGSize(width: 150, height: 120)
            sexvc.destination.modalPresentationStyle = .popover
            sexvc.destination.popoverPresentationController?.delegate = self
            sexvc.destination.popoverPresentationController?.sourceView = self.sexBtn
            sexvc.destination.popoverPresentationController?.sourceRect = self.sexBtn.bounds
            sexvc.destination.popoverPresentationController?.permittedArrowDirections = .any
            sexvc.destination.block = { [weak self] tuple in
                self?.sexLab.text = tuple.0
                self?.viewModel.rx_sex.value = tuple.1
            }
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
    
    deinit {
        plog("销毁了")
    }
   
}
extension RegistInformationController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if string == " " {
            return false
        }
        return true
    }
}
