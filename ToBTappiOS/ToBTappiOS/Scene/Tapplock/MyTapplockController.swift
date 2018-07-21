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
import PKHUD
class MyTapplockController: BaseViewController {
    
    @IBOutlet weak var bleBtn: UIButton!
    
    @IBOutlet weak var fingerBtn: UIButton!
    
    @IBOutlet weak var underLine: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var groupLab: UILabel!
    
    
   
    
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
     
        bleBtn.rx.tap.subscribe(onNext: { [weak self] in
            
            if self?.viewModel.rx_authType.value == 0 {
                return
            }
            self?.bleBtn.setTitleColor(UIColor.black, for: .normal)
            self?.fingerBtn.setTitleColor(UIColor("#cecece"), for: .normal)
            self?.underLine.transform = CGAffineTransform.identity
            
            self?.viewModel.rx_authType.value = 0
            self?.tableView.mj_header.beginRefreshing()
            
        }).disposed(by: rx.disposeBag)
        
        fingerBtn.rx.tap.subscribe(onNext: { [weak self] in

            if self?.viewModel.rx_authType.value == 1 {
                return
            }
            self?.fingerBtn.setTitleColor(UIColor.black, for: .normal)
            self?.bleBtn.setTitleColor(UIColor("#cecece"), for: .normal)
            self?.underLine.transform = CGAffineTransform.init(translationX: mScreenW / 2, y: 0)
            
            self?.viewModel.rx_authType.value = 1
            self?.tableView.mj_header.beginRefreshing()
            
        }).disposed(by: rx.disposeBag)
        
        
        viewModel.rx_lockList.asDriver()
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.tapplockListCellIdenty.identifier, cellType: TappLockListCell.self)) {
                (indexPath, model, cell) in
                
        }.disposed(by: rx.disposeBag)
        
        
        tableView.rx.modelSelected(TapplockModel.self).subscribe(onNext: { [weak self] model in
            
            if self?.isBLE == true {
                self?.performSegue(withIdentifier: R.segue.myTapplockController.showBLELockDetail, sender: self)
            
            } else {
                self?.performSegue(withIdentifier: R.segue.myTapplockController.showFingerLockDetail, sender: self)
            }
        }).disposed(by: rx.disposeBag)
        

        tableView.mj_header  = HeaderRefresh.init { [weak self] in
            self?.viewModel.loadAPI()
        }

        tableView.mj_footer = FooterRefresh.init(refreshingBlock: { [weak self] in
            self?.viewModel.loadMore()
        })
//
        viewModel.rx_step
            .asObservable()
            .subscribe(onNext: { [weak self] step in
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.mj_footer.endRefreshing()
                switch step {
                case .errorMessage(let mesg):
                    self?.showToast(message: mesg)
                default:
                    break
                }
            
        }).disposed(by: rx.disposeBag)
        
        self.viewModel.loadAPI()
        
    }
    
    @IBAction func rightSearchAction(_ sender: Any) {
        
        let nav = self.navigationController as! BaseNaviController
        nav.serch.serchShow()
        nav.serch.rx_text.asDriver().drive(viewModel.rx_lockName).disposed(by: rx.disposeBag)
        nav.serch.rx_action.asObservable()
            .subscribe(onNext: { [weak self] bl in
                if bl == false {
                    self?.viewModel.rx_lockName.value = nil
                } else {

                    self?.tableView.mj_header.beginRefreshing()
                }
        }).disposed(by: rx.disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
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
                self?.groupLab.text = model.groupName
                self?.viewModel.rx_groupId.value = model.id
                self?.tableView.mj_header.beginRefreshing()
            }
        }
    }
 

}
