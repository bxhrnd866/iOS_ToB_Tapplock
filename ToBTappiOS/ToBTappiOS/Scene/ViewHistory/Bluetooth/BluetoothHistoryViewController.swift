//
//  BluetoothHistoryViewController.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/19.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import MJRefresh
let headerIndenty = "BluetoothHistoryHeaderIndenty"
class BluetoothHistoryViewController: UIViewController {
    let viewModel = BluetoothHistoryViewModel.init()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
//        self.view.addSubview(noView)

        tableView.mj_header = RefreshGifheader(refreshingBlock: {
            self.viewModel.refresh()
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.viewModel.loadMoreHistory()
        })
        

        viewModel.rx_loading.asDriver()
                .drive(onNext: { [weak self] (loading) in
                    if !loading {
                        self?.tableView.mj_header.endRefreshing()
                        self?.tableView.mj_footer.endRefreshing()
//                        self?.noView.isHidden = !(self?.viewModel.dictSource.isEmpty)!
                        self?.tableView.reloadData()
                    }
                })
                .disposed(by: rx.disposeBag)

        viewModel.rx_loadAll.asDriver()
                .drive(onNext: { (all) in
                    if all {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    } else {
                        self.tableView.mj_footer.resetNoMoreData()
                    }
                })
                .disposed(by: rx.disposeBag)

        viewModel.rx_errorMessage.asDriver()
                .filter {
                    $0 != nil
                }
                .drive(onNext: { (message) in
                    self.showToast(message: message!)
                })
                .disposed(by: rx.disposeBag)



    }

}
extension BluetoothHistoryViewController: UITableViewDelegate, UITableViewDataSource  {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = [String](viewModel.dictSource.keys)[section]
        let source = viewModel.dictSource[key]?.count
    
        return source ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.bluetoothHistoryCell.identifier, for: indexPath) as! BluetoothHistoryCell
        
        let key = [String](viewModel.dictSource.keys)[indexPath.section]
        let source = viewModel.dictSource[key]!
        let moel = source[indexPath.row]
    
//        cell.setModel(moel)
        return cell
    }
    
}


