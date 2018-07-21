//
//  ViewHistoryController.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/14.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import Rswift
class ViewHistoryController: BaseViewController {

    @IBOutlet weak var bleBtn: UIButton!
    @IBOutlet weak var fingerBtn: UIButton!
    
    @IBOutlet weak var underLine: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        bleBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self?.bleBtn.setTitleColor(UIColor.black, for: .normal)
            self?.fingerBtn.setTitleColor(UIColor("#cecece"), for: .normal)
            
            self?.underLine.transform = CGAffineTransform.identity
            
            
        }).disposed(by: rx.disposeBag)
        
        fingerBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.scrollView.setContentOffset(CGPoint(x: mScreenW, y: 0), animated: true)
            self?.fingerBtn.setTitleColor(UIColor.black, for: .normal)
            self?.bleBtn.setTitleColor(UIColor("#cecece"), for: .normal)
            self?.underLine.transform = CGAffineTransform.init(translationX: mScreenW / 2, y: 0)
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        let nav = self.navigationController as! BaseNaviController
        nav.serch.serchShow()
//        nav.serch.rx_text.asDriver().drive(viewModel.rx_lockName).disposed(by: rx.disposeBag)
        nav.serch.rx_action.asObservable()
            .subscribe(onNext: { [weak self] bl in
                if bl == false {
//                    self?.viewModel.rx_lockName.value = nil
                } else {
//                    self?.viewModel.loadAPI()
                }
            }).disposed(by: rx.disposeBag)
        
    }
    
    @IBAction func searchCalendar(_ sender: Any) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        plog("history 销毁了")
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

extension ViewHistoryController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x
        
        let distance =   mScreenW * 3 / 4
        
        
        
        
        
    }
}
