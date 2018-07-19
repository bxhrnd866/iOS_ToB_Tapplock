//
//  MyTapplockController.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/14.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class MyTapplockController: BaseViewController {
    
    @IBOutlet weak var bleBtn: UIButton!
    
    @IBOutlet weak var fingerBtn: UIButton!
    
    @IBOutlet weak var underLine: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var naviView: UIView!
    
    var serch: SearchBar!
    
    let viewModel = TapplockViewModel()
    
    var isBLE: Bool! {
        if self.underLine.transform.tx == mScreenW / 2 {
            return false
        } else {
            return true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        bleBtn.rx.tap.subscribe(onNext: { [weak self] in
            
            self?.bleBtn.setTitleColor(UIColor.black, for: .normal)
            self?.fingerBtn.setTitleColor(UIColor("#cecece"), for: .normal)
            self?.underLine.transform = CGAffineTransform.identity
            
        }).disposed(by: rx.disposeBag)
        
        fingerBtn.rx.tap.subscribe(onNext: { [weak self] in

            self?.fingerBtn.setTitleColor(UIColor.black, for: .normal)
            self?.bleBtn.setTitleColor(UIColor("#cecece"), for: .normal)
            self?.underLine.transform = CGAffineTransform.init(translationX: mScreenW / 2, y: 0)
            
        }).disposed(by: rx.disposeBag)
        
        
        viewModel.lockList.asDriver()
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.tapplockListCellIdenty.identifier, cellType: TappLockListCell.self)) {
                (indexPath, model, cell) in
                
        }.disposed(by: rx.disposeBag)
        
    
        
        tableView.rx.modelSelected(TapplockModel.self).subscribe(onNext: { [weak self] model in
            
            if self?.isBLE == true {
//                self?.performSegue(withIdentifier: R.segue.myTapplockController.showBLELockDetail, sender: self)
                
                self?.serch.serchShow()
            } else {
//                self?.performSegue(withIdentifier: R.segue.myTapplockController.showFingerLockDetail, sender: self)
                self?.serch.cancelHidde()
            }
        }).disposed(by: rx.disposeBag)
        
        
        serch = SearchBar(frame: CGRect(x: 0, y: 0, width: mScreenW, height: 44))
        self.naviView.addSubview(serch)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        plog("tapplock 销毁了")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vm = R.segue.myTapplockController.showUserGroupSegue(segue: segue) {
            vm.destination.block = { [weak self] model in
                
            }
        }
    }
 

}
