//
//  FingerLockDetailController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PKHUD
import Instructions
class FingerLockDetailController: UIViewController {

    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var bgview: UIView!
    
    
    @IBOutlet weak var lockName: UILabel!
    @IBOutlet weak var naviTitle: UILabel!
    
    @IBOutlet weak var lockBattyImg: UIImageView!
    
    @IBOutlet weak var lockBattylab: UILabel!
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var leftBtn: UIButton!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    let viewModel = FingerDetailViewModel()
    let coachMarksController = CoachMarksController()
    
    @IBOutlet weak var historyBtn: HistoryGradientBtn!
    @IBOutlet weak var underLine: UIView!
    var handType: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgview.layer.shadowColor = UIColor.shadowColor.cgColor
        self.bgview.layer.shadowOffset = CGSize(width: 4, height: 7)
        self.bgview.layer.shadowOpacity = 0.7
        self.bgview.layer.shadowRadius = 5
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 84)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        
        self.collectView.collectionViewLayout = layout
        self.collectView.delegate = self
        self.collectView.dataSource = self
        
        
        naviTitle.text = viewModel.lock?.lockName
        lockName.text = viewModel.lock?.lockName
        groupName.text = viewModel.lock?.groupName
        if let num = viewModel.lock?.battery?.toInt() {
            lockBattylab.text = "\(num)" + "%"
            if num < 60 {
                lockBattylab.textColor = UIColor.themeColor
            } else {
                lockBattylab.textColor = UIColor.black
            }
            
            if num < 20 {
                lockBattyImg.image = R.image.lock_battery_0()
            } else if num < 40 {
                lockBattyImg.image = R.image.lock_battery_20()
            } else if num < 60 {
               lockBattyImg.image = R.image.lock_battery_40()
            } else if num < 80 {
                lockBattyImg.image = R.image.lock_battery_60()
            } else if num < 100 {
                lockBattyImg.image = R.image.lock_battery_80()
            } else if num == 100 {
                lockBattyImg.image = R.image.lock_battery_100()
            }
        } else {
            lockBattyImg.image = R.image.lock_battery_0()
            lockBattylab.text = "--"
        }
       
        viewModel.rx_step
            .asObservable()
            .subscribe(onNext: { [weak self] step in
                
                switch step {
                case .loading:
                    HUD.show(.progress)
                case .sucess:
                    HUD.hide()
                    self?.viewModel.dataSource.value = (self?.viewModel.leftSource)!
                    self?.collectView.reloadData()
                case .errorMessage(let mesg):
                    HUD.hide()
                    self?.showToast(message: mesg)
                default:
                    break
                }
                
            }).disposed(by: rx.disposeBag)
        
        
        leftBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.handType == false {
                    return
                }
                self?.handType = false
                self?.underLine.transform = CGAffineTransform.identity
                self?.viewModel.dataSource.value = (self?.viewModel.leftSource)!
                self?.collectView.reloadData()
        }).disposed(by: rx.disposeBag)
        
        rightBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.handType == true {
                    return
                }
                self?.handType = true
                self?.underLine.transform = CGAffineTransform.init(translationX: 50, y: 0)
                self?.viewModel.dataSource.value = (self?.viewModel.rightSource)!
                self?.collectView.reloadData()
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

    
    
    deinit {
        plog("销毁了")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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

extension FingerLockDetailController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.fingerprintListCollectCell.identifier, for: indexPath) as! FingerPrintListCollectionCell
        
        let model = viewModel.dataSource.value[indexPath.row]
        cell.tagLab.text = model.finger.text
        return cell
    }
}
//指南实现拓展
extension FingerLockDetailController: CoachMarksControllerDelegate,CoachMarksControllerDataSource {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        var hintText: String
        switch index {
        case 0:
            hintText = R.string.localizable.instructionLeftFingerPrint()
        case 1:
            hintText = R.string.localizable.instructionRightFingerPrint()
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
            return coachMarksController.helper.makeCoachMark(for: leftBtn)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: rightBtn)
        default:
            return coachMarksController.helper.makeCoachMark(for: historyBtn)
        }
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    
}
