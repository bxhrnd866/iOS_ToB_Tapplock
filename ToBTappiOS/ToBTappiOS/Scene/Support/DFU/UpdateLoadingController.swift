//
//  UpdateLoadingController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/26.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class UpdateLoadingController: UIViewController {

    @IBOutlet weak var statusLab: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var progressLab: UILabel!
    
    let viewModel = DFUViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.rx_step.asDriver().drive(onNext: { [weak self] (state) in
            switch state {
            case .downloading:
                
                self?.statusLab.text = R.string.localizable.downloadingBLE()
            case .downfail:
                
                self?.showToast(message: R.string.localizable.downloadfailed(), didDismiss: { _ in
                    self?.dismiss(animated: true, completion: {
                        self?.viewModel.sendDFUUpatestate(update: .downfail)
                    })
                })
            case .downSucess:
                self?.statusLab.text = ""
            case .updating:
                self?.statusLab.text = R.string.localizable.updatingDontTurnOff()
            case .updatefail:
                
                self?.showToast(message: R.string.localizable.installationfailed(), didDismiss: { _ in
                    
                    self?.dismiss(animated: true, completion: {
                        self?.viewModel.sendDFUUpatestate(update: .updatefail)
                    })
                })
            case .updateSucess:
                
                self?.dismiss(animated: true, completion: {
                    self?.viewModel.sendDFUUpatestate(update: .updateSucess)
                })
            default:
                break
            }
            
        }).disposed(by: rx.disposeBag)
        
        viewModel.rx_progress.asObservable().bind(to: progressView.rx.progress).disposed(by: rx.disposeBag)
        viewModel.rx_progress.asDriver().drive(onNext: { [weak self] value in
            let num = Int(value * 100)
            
            self?.progressLab.text = "\(num)%"
            
        }).disposed(by: rx.disposeBag)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.downloadUrl != nil {
            viewModel.downloadFirmware()
        }
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
