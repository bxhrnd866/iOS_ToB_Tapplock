//
//  AllLocksViewController.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/14.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AllLocksViewController: BaseViewController {

  
    @IBOutlet weak var tableView: UITableView!
    let viewModel = AllLockViewModel.init()
    
    @IBOutlet weak var groupLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.rx_locks.asDriver()
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.allLocksListCellIdenty.identifier, cellType: AllLocksCell.self)) {
                (indexPath, model, cell) in
                cell.model = model
            }.disposed(by: rx.disposeBag)
        
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if let vm = R.segue.allLocksViewController.showAllGroupSegue(segue: segue) {
            vm.destination.block = { [weak self] model in
                self?.groupLab.text = model.groupName
                self?.viewModel.rx_groupId.value = model.id
                self?.tableView.mj_header.beginRefreshing()
            }
        }
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        
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

    deinit {
        plog("AllLocks 销毁了")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
