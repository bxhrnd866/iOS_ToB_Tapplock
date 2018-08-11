//
//  LockDetailController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import PKHUD
import Instructions

class LockDetailController: UIViewController {

    
    @IBOutlet weak var bgview: UIView!
    
    @IBOutlet weak var lockName: UILabel!
    
    @IBOutlet weak var lockStatus: UILabel!
    
    @IBOutlet weak var battyLab: UILabel!
    
    @IBOutlet weak var groupLab: UILabel!
    
    @IBOutlet weak var navitItle: UILabel!
    
    @IBOutlet weak var batteryImg: UIImageView!
    
    @IBOutlet weak var unlock: unlockGradientBtn!
    
    @IBOutlet weak var historyBtn: HistoryGradientBtn!
    
    @IBOutlet weak var firmwareUpdate: UIButton!
    let viewModel = BlueDetailViewModel.init()
    let coachMarksController = CoachMarksController()
    
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
        
        viewModel.hardVersionUpdate()
        
        if let permissions = ConfigModel.default.user.value?.permissions {
            
            for model in permissions {
                if model.permissionCode == "303" {
                    self.firmwareUpdate.isHidden = false
                    break
                }
            }
        }
        
        
       
        self.firmwareUpdate.rx.tap.subscribe({ [weak self] _ in
            self?.performSegue(withIdentifier: R.segue.lockDetailController.showUpdateDFU, sender: self)
        }).disposed(by: rx.disposeBag)
        
        
        
        viewModel.rx_update.asDriver().drive(onNext: { [weak self] bl in
            
            if bl {
                self?.firmwareUpdate.backgroundColor = UIColor.themeColor
            } else {
                self?.firmwareUpdate.backgroundColor = UIColor("#F1F1F1")
            }
        }).disposed(by: rx.disposeBag)

        
        let instructionKey = String(describing: type(of: self))
        let instruction: Bool? = UserDefaults.standard.bool(forKey: instructionKey)
        if instruction == nil || !instruction! {
            UserDefaults.standard.set(true, forKey: instructionKey)
            self.coachMarksController.overlay.color = UIColor.overLayColor
            self.coachMarksController.overlay.allowTap = true
            self.coachMarksController.dataSource = self
            self.coachMarksController.delegate = self
            self.coachMarksController.start(on: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.hardVersionUpdate()
        
        
    }
    
    
    @IBAction func unlockAction(_ sender: Any) {
        if checkBlueWithAlert() {
          viewModel.unlockButtonAction()
        }
        
        loadAPI()
    }
    

    func loadAPI() {
        provider.rx.request(APIServer.downloadFingerprint(lockId: 9))
            .mapObject(APIResponseData<FingerprintDataModel>.self)
            .subscribe(onSuccess: { [weak self] response in
                
                plog(response.data)
                // 0 下载 1 删除
                if response.success {
                    guard let data = response.data else { return }
                    
                } else {
                    // 错误信息
                    //                    SyncView.instance.rx_hidden.value = true
                }
            }).disposed(by: rx.disposeBag)
    }
    
    
    deinit {
        plog("销毁了")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = R.segue.lockDetailController.showUpdateDFU(segue: segue) {
            vc.destination.updateModel = viewModel.updateModel
        }
    }
}

//指南实现拓展
extension LockDetailController: CoachMarksControllerDelegate,CoachMarksControllerDataSource {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        var hintText: String
        switch index {
        case 0:
            hintText = R.string.localizable.instructionUnlock()
        default:
            hintText = R.string.localizable.instructionsHistorylist()
        }
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true,
                                                                           arrowOrientation: coachMark.arrowOrientation,
                                                                           hintText: hintText,
                                                                           nextText: nil)
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: unlock)
     
        default:
            return coachMarksController.helper.makeCoachMark(for: historyBtn)
        }
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    
    
}
