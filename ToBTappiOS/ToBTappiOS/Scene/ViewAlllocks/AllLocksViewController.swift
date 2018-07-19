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
    
    deinit {
        plog("AllLocks 销毁了")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
