//
//  ViewHistoryController.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/14.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum HistoryTab {
    case bluetooth
    case fingerprint
}

enum RefreshTap {
    case none
    case blue
    case finger
}

class ViewHistoryController: UIViewController {
    
    @IBOutlet weak var bleBtn: UIButton!
    @IBOutlet weak var fingerBtn: UIButton!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
 
    
    var rx_tab = Variable(HistoryTab.bluetooth)
    var rx_refresh = Variable(RefreshTap.none)
    
    
    
    var rx_targetName: Variable<String?> = Variable(nil)
    var rx_beginTime: Variable<Int?> = Variable(nil)
    var rx_endTime: Variable<Int?> = Variable(nil)
    var startLab: String?
    var endLab: String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bleBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.rx_tab.value = HistoryTab.bluetooth
        }).disposed(by: rx.disposeBag)
        
        fingerBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.rx_tab.value = HistoryTab.fingerprint
        }).disposed(by: rx.disposeBag)
        
        
        rx_tab.asDriver()
            .drive(onNext: { [weak self] tab in
                
                switch tab {
                case .bluetooth:
                    self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self?.bleBtn.setTitleColor(UIColor.black, for: .normal)
                    self?.fingerBtn.setTitleColor(UIColor("#cecece"), for: .normal)
                    self?.underLine.transform = CGAffineTransform.identity
                    
                case .fingerprint:
                    
                    self?.scrollView.setContentOffset(CGPoint(x: mScreenW, y: 0), animated: true)
                    self?.fingerBtn.setTitleColor(UIColor.black, for: .normal)
                    self?.bleBtn.setTitleColor(UIColor("#cecece"), for: .normal)
                    self?.underLine.transform = CGAffineTransform.init(translationX: mScreenW / 2, y: 0)
                }
        }).disposed(by: rx.disposeBag)
        
        
     
        
    }
    
    
    @IBAction func searchActionSelect(_ sender: Any) {

        self.performSegue(withIdentifier: R.segue.viewHistoryController.showSearchViewIdentifier, sender: self)
        
    }
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        plog("history 销毁了")
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = R.segue.viewHistoryController.bleHistoryIdentifer(segue: segue) {
            vc.destination.controller = self
        }
        
        if let vc = R.segue.viewHistoryController.fingerPrintHistoryIdentifier(segue: segue) {
            vc.destination.controller = self
        }
        
        if let vc = R.segue.viewHistoryController.showSearchViewIdentifier(segue: segue) {
            vc.destination.controller = self
            vc.destination.callblock = { [weak self] in
                self?.startLab = vc.destination.Startlab.text
                self?.endLab = vc.destination.endLab.text
                self?.rx_targetName.value = vc.destination.textfield.text
                self?.rx_beginTime.value = vc.destination.rx_startTime.value
                self?.rx_endTime.value = vc.destination.rx_endTime.value
                
                if self?.rx_tab.value == .bluetooth {
                    self?.rx_refresh.value = RefreshTap.blue
                } else {
                    self?.rx_refresh.value = RefreshTap.finger
                }
            }
        }
    }
 

}

extension ViewHistoryController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        if scrollView.contentOffset.x == 0 {
            self.rx_tab.value = .bluetooth
        } else {
            self.rx_tab.value = .fingerprint
        }
    }
}
