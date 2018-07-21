//
//  AllLocksViewController.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/14.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class AllLocksViewController: BaseViewController {

  
    @IBOutlet weak var tableView: UITableView!
    let viewModel = AllLockViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.rx_locks.asDriver()
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.allLocksListCellIdenty.identifier, cellType: AllLocksCell.self)) {
                (indexPath, model, cell) in

            }.disposed(by: rx.disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if let vm = R.segue.allLocksViewController.showAllGroupSegue(segue: segue) {
            vm.destination.block = {
                
            }
        }
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
    
    deinit {
        plog("AllLocks 销毁了")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
