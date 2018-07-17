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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        data.asDriver()
            .drive(tableview.rx.items(cellIdentifier: R.reuseIdentifier.bluetoothHistoryCell.identifier,
                                      cellType: BluetoothHistoryCell.self)) { (indexPath, model, cell) in
                                      cell.locationLabel.text = "这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊这是一个地址吗好开心啊"
            }
            .disposed(by: rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
