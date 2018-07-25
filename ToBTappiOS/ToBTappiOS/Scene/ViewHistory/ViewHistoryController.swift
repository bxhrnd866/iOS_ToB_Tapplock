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

class ViewHistoryController: UIViewController {
    
    @IBOutlet weak var bleBtn: UIButton!
    @IBOutlet weak var fingerBtn: UIButton!
    @IBOutlet weak var underLine: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
 
    var rx_tab = Variable(HistoryTab.bluetooth)
    var rx_lockName: Variable<String?> = Variable(nil)
    var rx_beginTime: Variable<Int?> = Variable(nil)
    var rx_endTime: Variable<Int?> = Variable(nil)

    
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
    
    
    @IBAction func searchAction(_ sender: Any) {
        self.searchBar?.serchShow()
        searchBar?.rx_text.asDriver().drive(self.rx_lockName).disposed(by: rx.disposeBag)
        searchBar?.rx_action.asObservable()
            .subscribe(onNext: { [weak self] bl in

                if bl {
                
                } else {
                    self?.rx_lockName.value = nil
                }
            }).disposed(by: rx.disposeBag)
        
    }
    
    @IBAction func searchCalendar(_ sender: Any) {
        self.performSegue(withIdentifier: R.segue.viewHistoryController.showHistoryDatePicker, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if self.rx_lockName.value != nil, self.rx_lockName.value?.length != 0 {
            self.searchBar?.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.rx_lockName.value?.length == 0 || self.rx_lockName.value == nil {
            self.searchBar?.cancelHidde()
        } else  {
            self.searchBar?.isHidden = true
        }
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
    }
 

}

extension ViewHistoryController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        let x = scrollView.contentOffset.x
//
//        let distance =   mScreenW * 3 / 4
//
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        if scrollView.contentOffset.x == 0 {
            self.rx_tab.value = .bluetooth
        } else {
            self.rx_tab.value = .fingerprint
        }
    }
}
