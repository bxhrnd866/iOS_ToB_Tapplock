//
//  NotificationController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/8/2.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NotificationController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    let viewModel = NotificationViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.rx_data.asDriver()
            .drive(tableview.rx.items(cellIdentifier: R.reuseIdentifier.notificationCenterIdentifier.identifier, cellType: NotifactionCell.self)) {
                (indexPath, model, cell) in
                
            
            }.disposed(by: rx.disposeBag)
       
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
