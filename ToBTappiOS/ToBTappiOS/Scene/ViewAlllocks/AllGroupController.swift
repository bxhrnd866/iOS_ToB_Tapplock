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
import PKHUD
class AllGroupController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var groups = Variable([GroupsModel]())
    
    var block: ((GroupsModel)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groups.asDriver()
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.allGroupCellIdenty.identifier, cellType: AllGroupCell.self)) {
                (indexPath, model, cell) in
                cell.groupLab.text = model.groupName
            }.disposed(by: rx.disposeBag)
        
        tableView.rx.modelSelected(GroupsModel.self)
            .subscribe(onNext: { [weak self] model in
                if self?.block != nil {
                    self?.block!(model)
                    self?.navigationController?.popViewController(animated: true)
                }
                
            }).disposed(by: rx.disposeBag)
        loadAPI()
    }

    func loadAPI() {
        HUD.show(.progress)
        provider.rx.request(APIServer.allGroupslist)
            .mapObject(APIResponseData<GroupsModel>.self)
            .subscribe(onSuccess: { [weak self] response in
                HUD.hide()
                if response.success {
                    if response.data != nil {
                        self?.groups.value = response.data!
                        let model = GroupsModel.init()
                        model.groupName = R.string.localizable.allGroup()
                        self?.groups.value.insert(model, at: 0)
                    }
                } else {
                    
                    if response.codeMessage != nil {
                        self?.showToast(message: response.codeMessage!)
                    } 
                }
            
            }) { ( error) in
                HUD.hide()
            }.disposed(by: rx.disposeBag)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
