//
//  UserGroupController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class UserGroupController: UIViewController {

    var block: ((GroupsModel)->())?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ConfigModel.default.user.value?.rx_groups.asDriver()
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.userGroupCellIdenty.identifier, cellType: UserGroupCell.self)) {
                (indexPath, model, cell) in
                cell.model = model
            }.disposed(by: rx.disposeBag)
        
        tableView.rx.modelSelected(GroupsModel.self)
            .subscribe(onNext: { [weak self] model in
                if self?.block != nil {
                    self?.block!(model)
                    self?.navigationController?.popViewController(animated: true)
                }
                
        }).disposed(by: rx.disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

