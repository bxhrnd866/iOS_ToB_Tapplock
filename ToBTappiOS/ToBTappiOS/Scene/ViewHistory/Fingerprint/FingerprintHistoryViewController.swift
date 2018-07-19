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
    let viewModel = FingerprintHistoryViewModel.init()
    var data = Variable(["22","333","22","333","22","333","22","333","22","333"])
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.refresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.asDriver()
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.fingerprintHistoryCell.identifier,
                                      cellType: FingerPrintListCell.self)) { (indexPath, model, cell) in
                                        
                                        cell.decriptionLab.text = "这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊"
            }
            .disposed(by: rx.disposeBag)
        
        
        
//        tableView.mj_header = RefreshGifheader(refreshingBlock: {
//            self.viewModel.refresh()
//        })
//
//        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
//            self.viewModel.loadMoreHistory()
//        })
//
//        viewModel.rx_loading.asDriver()
//                .drive(onNext: { [weak self] (loading) in
//                    if !loading {
//                        self?.tableView.mj_header.endRefreshing()
//                        self?.tableView.mj_footer.endRefreshing()
//                        self?.tableView.reloadData()
//                    }
//                })
//                .disposed(by: rx.disposeBag)
//
//        viewModel.rx_loadAll.asDriver()
//                .drive(onNext: { (all) in
//                    if all {
//                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
//                    } else {
//                        self.tableView.mj_footer.resetNoMoreData()
//                    }
//                })
//                .disposed(by: rx.disposeBag)
//
//        viewModel.rx_errorMessage.asDriver()
//                .filter {
//                    $0 != nil
//                }
//                .drive(onNext: { (message) in
//                    self.showToast(message: message!)
//                })
//                .disposed(by: rx.disposeBag)


        
//        viewModel.rx_historys.asDriver().drive(onNext: { [weak self] (data) in
//            self?.tableView.reloadData()
//        }).disposed(by: rx.disposeBag)
        
    
        
    }

}

//extension FingerprintHistoryViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let key = [String](viewModel.dictSource.keys)[section]
//        let source = viewModel.dictSource[key]?.count
//        
//        return source ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        let key = [String](viewModel.dictSource.keys)[indexPath.section]
//        let source = viewModel.dictSource[key]!
//        let model = source[indexPath.row]
//        if model.closeTime != nil {
//            return 76
//        }
//        return 50
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel.dictSource.keys.count
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIndenty) as? HistoryTableHeaderView
//        if header == nil {
//            header = HistoryTableHeaderView(reuseIdentifier: headerIndenty)
//        }
//        
//        let key = [String](viewModel.dictSource.keys)[section]
//        let source = viewModel.dictSource[key]?.count
//        
//        header?.labItems?.text = "\(source ?? 0) items"
//        header?.labTime?.text = key
//    
//        return header
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 26
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let key = [String](viewModel.dictSource.keys)[indexPath.section]
//        let source = viewModel.dictSource[key]!
//        let model = source[indexPath.row]
//        
//        if model.closeTime != nil {
//            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.fingerprintHistoryCell.identifier, for: indexPath) as! FingerPrintListCell
//            cell.setModel(model)
//            return cell
//        }
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.lockAFingerPrint.identifier, for: indexPath) as! LockAFingPrintCell
//        cell.setModel(model)
//        return cell
//    }
//}
//
