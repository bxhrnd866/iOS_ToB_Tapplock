//
//  AllGroupController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class AllGroupController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let groups = Variable(["xxx", "222", "344", "55555", "yyyyy"])
    
    var block: (()->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groups.asDriver()
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.allGroupCellIdenty.identifier, cellType: AllGroupCell.self)) {
                (indexPath, model, cell) in
               
            }.disposed(by: rx.disposeBag)
        
        tableView.rx.modelSelected(GroupsModel.self)
            .subscribe(onNext: { [weak self] model in
                if self?.block != nil {
                    self?.block!()
                    self?.navigationController?.popViewController(animated: true)
                }
                
            }).disposed(by: rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
