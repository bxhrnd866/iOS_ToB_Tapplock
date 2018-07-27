//
//  LockDetailController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import PKHUD
class LockDetailController: UIViewController {

    
    @IBOutlet weak var bgview: UIView!
    
    @IBOutlet weak var lockName: UILabel!
    
    @IBOutlet weak var lockStatus: UILabel!
    
    @IBOutlet weak var battyLab: UILabel!
    
    @IBOutlet weak var groupLab: UILabel!
    
    @IBOutlet weak var navitItle: UILabel!
    
    @IBOutlet weak var batteryImg: UIImageView!
    
    let viewModel = BlueDetailViewModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgview.layer.shadowColor = UIColor.shadowColor.cgColor
        self.bgview.layer.shadowOffset = CGSize(width: 4, height: 7)
        self.bgview.layer.shadowOpacity = 0.7
        self.bgview.layer.shadowRadius = 5
        

        navitItle.text = viewModel.lock?.lockName
        lockName.text = viewModel.lock?.lockName
        groupLab.text = viewModel.lock?.groupName
        
        
        viewModel.rx_lockStatus.asObservable().subscribe(onNext: { [weak self] text in
            plog(text)
            self?.lockStatus.text = text
            if text == R.string.localizable.connected() {
                self?.lockStatus.textColor = UIColor("#3effbf")
            } else {
                self?.lockStatus.textColor = UIColor("#d1d0d6")
            }
        }).disposed(by: rx.disposeBag)
        
        
        viewModel.rx_batteryLabelText.asDriver().drive(onNext: { [weak self] batt in
            
            self?.battyLab.text = batt
            guard let num = Int(batt) else {
                self?.batteryImg.image = R.image.lock_battery_0()
                return
            }
            self?.battyLab.text = batt + "%"
            
            if num < 60 {
                self?.battyLab.textColor = UIColor.themeColor
            } else {
                self?.battyLab.textColor = UIColor.black
            }
            
            if num < 20 {
                self?.batteryImg.image = R.image.lock_battery_0()
            } else if num < 40 {
                self?.batteryImg.image = R.image.lock_battery_20()
            } else if num < 60 {
                self?.batteryImg.image = R.image.lock_battery_40()
            } else if num < 80 {
                self?.batteryImg.image = R.image.lock_battery_60()
            } else if num < 100 {
                self?.batteryImg.image = R.image.lock_battery_80()
            } else if num == 100 {
                self?.batteryImg.image = R.image.lock_battery_100()
            }
            
        }).disposed(by: rx.disposeBag)
        
        
        viewModel.rx_step
            .asObservable()
            .subscribe(onNext: { [weak self] step in
           
                switch step {
                case .loading:
                    HUD.show(.progress)
                case .sucess:
                    HUD.hide()
                case .errorMessage(let mesg):
                    HUD.hide()
                    self?.showToast(message: mesg)
                default:
                    break
                }
                
            }).disposed(by: rx.disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    @IBAction func unlockAction(_ sender: Any) {
        if checkBlueWithAlert() {
          viewModel.unlockButtonAction()
        }
        
    }
    
    @IBAction func firmwareUpdateAction(_ sender: Any) {
        
          self.performSegue(withIdentifier: R.segue.lockDetailController.showUpdateDFU, sender: self)
    }
    deinit {
        plog("销毁了")
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
