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
    
    let viewModel = LockHistoryViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        data.asDriver()
//            .drive(tableview.rx.items(cellIdentifier: R.reuseIdentifier.bluetoothHistoryCell.identifier,
//                                      cellType: BluetoothHistoryCell.self)) { (indexPath, model, cell) in
//                                      cell.locationLabel.text = "这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊"
//            }
//            .disposed(by: rx.disposeBag)
        
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
        
        self.viewModel.loadAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)       
     
    }
}

extension BlueHistoryController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = [String](viewModel.dictSource.keys)[section]
        let source = viewModel.dictSource[key]?.count
        
        return source ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
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
        cell.model = source[indexPath.row]
        return cell
    }
    
}



