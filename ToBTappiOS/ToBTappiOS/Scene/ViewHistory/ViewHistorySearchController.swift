//
//  ViewHistorySearchController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/27.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class ViewHistorySearchController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var tiemBg: UIView!
    
    @IBOutlet weak var Startlab: UILabel!
    
    @IBOutlet weak var endLab: UILabel!
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var endBtn: UIButton!
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var reset: UIButton!
    
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBOutlet weak var timepicker: UIDatePicker!
    
    @IBOutlet weak var dateBtn: UIButton!
    
    @IBOutlet weak var timeBtn: UIButton!
    
    weak var controller: ViewHistoryController?
    
   
    
    var rx_startTime: Variable<Int?> = Variable(nil)
    var rx_endTime: Variable<Int?> = Variable(nil)

    var rx_type = Variable(TimeType.start)
    var rx_date = Variable(DateType.date)
    
    var callblock: (()->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textfield.tintColor = UIColor.themeColor
        
        self.textfield.text = controller?.rx_targetName.value

        self.rx_endTime.value = controller?.rx_endTime.value
        self.rx_startTime.value = controller?.rx_beginTime.value
        self.Startlab.text = controller?.startLab
        self.endLab.text = controller?.endLab
        
        
        self.tiemBg.transform = CGAffineTransform.init(translationX: 0, y: 350)
        
        reset.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.textfield.text = nil
                self?.Startlab.text = nil
                self?.endLab.text = nil
                self?.showDate(show: false)
                self?.rx_startTime.value = nil
                self?.rx_endTime.value = nil
                self?.textfield.resignFirstResponder()
                
        }).disposed(by: rx.disposeBag)
        
        searchBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.textfield.resignFirstResponder()
                if (self?.canSave())! {
                    self?.controller?.startLab = self?.Startlab.text
                    self?.controller?.endLab = self?.endLab.text
                    self?.controller?.rx_targetName.value = self?.textfield.text
                    self?.controller?.rx_beginTime.value = self?.rx_startTime.value
                    self?.controller?.rx_endTime.value = self?.rx_endTime.value
    
                    
                    
                    self?.dismiss(animated: true, completion: nil)
                    if self?.callblock != nil {
                        self?.callblock!()
                    }
                }
                
                //搜索
        }).disposed(by: rx.disposeBag)
        
        
        startBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.textfield.resignFirstResponder()
                self?.rx_type.value = .start
                self?.showDate(show: true)
                self?.startBtn.setImage(R.image.bottomArrow(), for: .normal)
                self?.endBtn.setImage(R.image.rightArrow(), for: .normal)
                
                
            }).disposed(by: rx.disposeBag)
        
        endBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.textfield.resignFirstResponder()
                self?.rx_type.value = .end
                self?.showDate(show: true)
                self?.startBtn.setImage(R.image.rightArrow(), for: .normal)
                self?.endBtn.setImage(R.image.bottomArrow(), for: .normal)
                
            }).disposed(by: rx.disposeBag)
        
        dateBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                
                self?.datepicker.isHidden = false
                self?.timepicker.isHidden = true
                self?.rx_date.value = .date
                self?.dateBtn.setTitleColor(UIColor.themeColor, for: .normal)
                self?.timeBtn.setTitleColor(UIColor.black, for: .normal)
                
        }).disposed(by: rx.disposeBag)
        
        timeBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                
                self?.datepicker.isHidden = true
                self?.timepicker.isHidden = false
                self?.rx_date.value = .time
                self?.timeBtn.setTitleColor(UIColor.themeColor, for: .normal)
                self?.dateBtn.setTitleColor(UIColor.black, for: .normal)
                
        }).disposed(by: rx.disposeBag)
 
        
       
    }
    
    
    @IBAction func bgBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnSelect(_ sender: Any) {
        showDate(show: false)
    }
    
    @IBAction func saveBtnSelect(_ sender: Any) {
        
        switch self.rx_date.value {
        case .date:

            let da = self.datepicker.date
            let time = da.string(custom: "yyyy-MM-dd")
            let stamp = (time + " 00:00:00").timeStamp

            switch self.rx_type.value {
            case .start:
                self.Startlab.text = time
                self.rx_startTime.value = stamp
            case .end:
                self.endLab.text = time
                self.rx_endTime.value = stamp
            }

        case .time:

            let da = self.timepicker.date
            let time = da.string(custom: "yyyy-MM-dd HH:mm")
            switch self.rx_type.value {
            case .start:
                self.Startlab.text = time
                self.rx_startTime.value = Int(da.timeIntervalSince1970)
            case .end:
                self.endLab.text = time
                self.rx_endTime.value = Int(da.timeIntervalSince1970)
            }
        }


        showDate(show: false)
    }
    
 
    func showDate(show: Bool){
        self.startBtn.setImage(R.image.rightArrow(), for: .normal)
        self.endBtn.setImage(R.image.rightArrow(), for: .normal)
        UIView.animate(withDuration: 0.6) {
            self.tiemBg.transform = show ? CGAffineTransform.identity : CGAffineTransform.init(translationX: 0, y: 350)
        }
    }
    
    func canSave() -> Bool {
        if self.rx_startTime.value != nil && self.rx_endTime.value != nil {
            if self.rx_startTime.value! > self.rx_endTime.value! {
                let x = R.string.localizable.errorMessage_ShareStartTimeEndTime()
                self.showToast(message: x)
                return false
            } else {
               
                return true
            }
        } else if (self.textfield.text?.containsEmoji)! {
            self.showToast(message: R.string.localizable.errorMessage_Emoji())
            return false
        }
        return true
    }
    
    deinit {
        plog("search 销毁了")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
