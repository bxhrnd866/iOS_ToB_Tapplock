//
//  HistoryDateController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/25.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftDate

enum TimeType {
    case start
    case end
}

enum DateType {
    case date
    case time
}

class HistoryDateController: UIViewController {

    @IBOutlet weak var startLab: UILabel!
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endLab: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var DateBtn: UIButton!
    @IBOutlet weak var TimeBtn: UIButton!

    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var timepicker: UIDatePicker!
    
    var rx_type = Variable(TimeType.start)
    var rx_date = Variable(DateType.date)
    
    var rx_startTime: Variable<Int?> = Variable(nil)
    var rx_endTime: Variable<Int?> = Variable(nil)
    
    
    
    var block: (((Int?, Int?))->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timepicker.isHidden = true
        
        rx_type.asDriver()
            .drive(onNext: { [weak self] type in
                switch type {
                case .start:
                    self?.startLab.textColor = UIColor.themeColor
                    self?.startTime.textColor = UIColor.themeColor
                    self?.endLab.textColor = UIColor.black
                    self?.endTime.textColor = UIColor.black
            
                case .end:
                    self?.startLab.textColor = UIColor.black
                    self?.startTime.textColor = UIColor.black
                    self?.endLab.textColor = UIColor.themeColor
                    self?.endTime.textColor = UIColor.themeColor
                }
                
        }).disposed(by: rx.disposeBag)
        
        
        rx_date.asDriver()
            .drive(onNext: { [weak self] type in
                switch type {
                case .date:
                    self?.DateBtn.setTitleColor(UIColor.themeColor, for: .normal)
                    self?.TimeBtn.setTitleColor(UIColor.black, for: .normal)
                    self?.timepicker.isHidden = true
                    self?.datePicker.isHidden = false
                    
                case .time:
                    
                    self?.TimeBtn.setTitleColor(UIColor.themeColor, for: .normal)
                    self?.DateBtn.setTitleColor(UIColor.black, for: .normal)
                    self?.timepicker.isHidden = false
                    self?.datePicker.isHidden = true
                }
            
        }).disposed(by: rx.disposeBag)

       
        DateBtn.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.rx_date.value = .date
        }).disposed(by: rx.disposeBag)
        
        TimeBtn.rx.tap.subscribe(onNext: { [weak self] _ in
             self?.rx_date.value = .time
        }).disposed(by: rx.disposeBag)
        
        
        datePicker.rx.controlEvent([.valueChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                
                let da = (self?.datePicker.date)!
                let time = da.string(custom: "yyyy-MM-dd")
                let stamp = (time + " 00:00:00").timeStamp
                
                switch (self?.rx_type.value)! {
                case .start:
                    self?.startTime.text = time
                    self?.rx_startTime.value = stamp
                case .end:
                    self?.endTime.text = time
                    self?.rx_endTime.value = stamp
               
                }

            }).disposed(by: rx.disposeBag)
        
        timepicker.rx.controlEvent([.valueChanged])
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                
                let da = (self?.timepicker.date)!
                plog(da)
                let time = da.string(custom: "yyyy-MM-dd HH:mm")
                switch (self?.rx_type.value)! {
                case .start:
                    self?.rx_startTime.value = Int(da.timeIntervalSince1970)
                    self?.startTime.text = time
                case .end:
                    self?.endTime.text = time
                    self?.rx_endTime.value = Int(da.timeIntervalSince1970)
                }
                
            }).disposed(by: rx.disposeBag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if canSave() {
            if self.block != nil {
                self.dismiss(animated: true, completion: nil)
                self.block!((rx_startTime.value,rx_endTime.value))
            }
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
        } else {
            return true
        }
    }
    
    @IBAction func endBtnAction(_ sender: Any) {
        self.rx_type.value = .end
    }
    @IBAction func startBtnAction(_ sender: Any) {
        self.rx_type.value = .start
        
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
