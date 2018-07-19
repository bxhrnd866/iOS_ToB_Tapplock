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

extension ViewHistoryController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x
        
        let distance =   mScreenW * 3 / 4
        
        
        
        
        
    }
}
