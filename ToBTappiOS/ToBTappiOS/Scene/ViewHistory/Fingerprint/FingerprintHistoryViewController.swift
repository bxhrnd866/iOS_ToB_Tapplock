//
//  FingerprintHistoryViewController.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/19.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import MJRefresh
import RxCocoa
import RxSwift

class FingerprintHistoryViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    weak var controller: ViewHistoryController?
    let viewModel = LockHistoryViewModel(type: 0)
 
    override func viewDidLoad() {
        super.viewDidLoad()

        controller?.rx_targetName.asObservable().bind(to: viewModel.rx_targetName).disposed(by: rx.disposeBag)
        controller?.rx_endTime.asObservable().bind(to: viewModel.rx_endTime).disposed(by: rx.disposeBag)
        controller?.rx_beginTime.asObservable().bind(to: viewModel.rx_beginTime).disposed(by: rx.disposeBag)
        
        controller?.rx_refresh.asDriver().drive(onNext: { [weak self] tap in
            if tap ==  RefreshTap.finger {
                self?.tableView.mj_header.beginRefreshing()
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
                self?.tableView.reloadData()
                switch step {
                case .errorMessage(let mesg):
                    self?.showToast(message: mesg)
                default:
                    break
                }
                
            }).disposed(by: rx.disposeBag)
        
        self.viewModel.loadAPI()
        
    }

}


extension FingerprintHistoryViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = [String](viewModel.dictSource.keys)[section]
        let source = viewModel.dictSource[key]?.count
        
        return source ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
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
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.bluetoothHistoryCell.identifier, for: indexPath) as! FingerPrintListCell
        
        let key = [String](viewModel.dictSource.keys)[indexPath.section]
        let source = viewModel.dictSource[key]!
        cell.model = source[indexPath.row]
        return cell
    }
    
}
