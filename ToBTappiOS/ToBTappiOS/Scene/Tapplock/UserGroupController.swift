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
import PKHUD
class UserGroupController: UIViewController {

    var block: ((GroupsModel)->())?

    let viewModel = UserGroupViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.rx_step
            .asObservable()
            .subscribe(onNext: { [weak self] step in
              
                switch step {
                case .loading:
                    HUD.show(.progress)
                case .sucess:
                    HUD.hide()
                case .failed:
                    HUD.hide()
                case .errorMessage(let mesg):
                    HUD.hide()
                    self?.showToast(message: mesg)
                default:
                    break
                }
                
            }).disposed(by: rx.disposeBag)
        viewModel.rx_data.asDriver()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadAPI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

