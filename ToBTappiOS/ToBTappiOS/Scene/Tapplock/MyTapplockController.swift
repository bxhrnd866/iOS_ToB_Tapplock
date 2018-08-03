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
                cell.model = model
                
        }.disposed(by: rx.disposeBag)
        
        
        tableView.rx.modelSelected(TapplockModel.self).subscribe(onNext: { [weak self] model in
             TapplockManager.default.editingLock = model
            if self?.isBLE == true {
                self?.performSegue(withIdentifier: R.segue.myTapplockController.showBLELockDetail, sender: self)
            } else {
                self?.performSegue(withIdentifier: R.segue.myTapplockController.showFingerLockDetail, sender: self)
            }
        }).disposed(by: rx.disposeBag)
        

        tableView.mj_header  = HeaderRefresh.init { [weak self] in
            self?.viewModel.loadRefresh()
        }

        tableView.mj_footer = FooterRefresh.init(refreshingBlock: { [weak self] in
            self?.viewModel.loadMore()
        })

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
        
        viewModel.rx_loadAll.asDriver()
            .drive(onNext: { [weak self] all in
                
                if all {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self?.tableView.mj_footer.resetNoMoreData()
                }
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.loadAPI()
        
    }
    
    @IBAction func rightSearchAction(_ sender: Any) {
        
        self.searchBar?.serchShow()
        searchBar?.rx_text.asDriver().drive(viewModel.rx_lockName).disposed(by: rx.disposeBag)
        searchBar?.rx_action.asObservable()
            .subscribe(onNext: { [weak self] bl in
               
                if bl {
                    self?.tableView.mj_header.beginRefreshing()
                } else {
                    self?.viewModel.rx_lockName.value = nil
                }
        }).disposed(by: rx.disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if viewModel.rx_lockName.value != nil, viewModel.rx_lockName.value?.length != 0 {
            self.searchBar?.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewModel.rx_lockName.value?.length == 0 || viewModel.rx_lockName.value == nil {
            self.searchBar?.cancelHidde()
        } else  {
            self.searchBar?.isHidden = true
        }
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
