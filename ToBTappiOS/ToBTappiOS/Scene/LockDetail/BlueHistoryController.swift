//
//  BlueHistoryController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class BlueHistoryController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var data = Variable(["22","333","22","333","22","333","22","333","22","333"])
    
    let viewModel = LockHistoryViewModel(type: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        tableview.mj_header  = HeaderRefresh.init { [weak self] in
            self?.viewModel.loadRefresh()
        }
        
        tableview.mj_footer = FooterRefresh.init(refreshingBlock: { [weak self] in
            self?.viewModel.loadMore()
        })
        
        viewModel.rx_step
            .asObservable()
            .subscribe(onNext: { [weak self] step in
                self?.tableview.mj_header.endRefreshing()
                self?.tableview.mj_footer.endRefreshing()
                self?.tableview.reloadData()
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
                    self?.tableview.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self?.tableview.mj_footer.resetNoMoreData()
                }
            }).disposed(by: rx.disposeBag)
        
        
        self.viewModel.loadAPI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = R.segue.blueHistoryController.showHistoryDate(segue: segue) {
            vc.destination.block = { [weak self] tuple in
                self?.viewModel.rx_beginTime.value = tuple.0
                self?.viewModel.rx_endTime.value = tuple.1
                self?.tableview.mj_header.beginRefreshing()
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)       
     
    }
    
    deinit {
        plog("销毁了")
    }
}

extension BlueHistoryController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = [String](viewModel.dictSource.keys)[section]
        let source = viewModel.dictSource[key]?.count
        
        return source ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let key = [String](viewModel.dictSource.keys)[indexPath.section]
        let source = viewModel.dictSource[key]!
        let model = source[indexPath.row]
        
        let height = model.cellHeight ?? 20
        return 100 + height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dictSource.keys.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIndenty) as? HistoryTableHeaderView
        if header == nil {
            header = HistoryTableHeaderView(reuseIdentifier: headerIndenty)
        }
        
        let key = [String](viewModel.dictSource.keys)[section]
        let source = viewModel.dictSource[key]?.count
        
        header?.labItems?.text = "\(source ?? 0) items"
        header?.labTime?.text = key
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.blueLockDetailIdentyCell.identifier , for: indexPath) as! BlueLockDetailCell
        
        let key = [String](viewModel.dictSource.keys)[indexPath.section]
        let source = viewModel.dictSource[key]!
        cell.model = source[indexPath.row]
        
        
        return cell
    }
    
}



