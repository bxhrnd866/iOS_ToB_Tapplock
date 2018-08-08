//
//  SendFeedbackController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/6.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import PKHUD
class SendFeedbackController: UIViewController {

   
    @IBOutlet weak var titlefIeld: UITextField!
    
    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var sendBtn: UIBarButtonItem!
    
    let viewModel = EditUserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titlefIeld.rx.text.bind(to: viewModel.rx_title).disposed(by: rx.disposeBag)
        content.rx.text.bind(to: viewModel.rx_description).disposed(by: rx.disposeBag)
        
        sendBtn.rx.tap.subscribe({ [weak self] _ in
            self?.viewModel.sendFeedBack()
        }).disposed(by: rx.disposeBag)
        

        viewModel.rx_step.asDriver().drive(onNext: { [weak self] step in
            
            switch step {
            case .loading:
                HUD.show(.progress)
            case .sucess:
                HUD.hide()
                self?.showToast(message: R.string.localizable.successMessage_Feedback(),
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
