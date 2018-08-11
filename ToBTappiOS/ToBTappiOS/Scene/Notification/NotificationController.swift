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
        
        viewModel.rx_refresh.asDriver().drive(onNext: { [weak self] bl in
            if bl {
                self?.tableview.reloadData()
            }
            
        }).disposed(by: rx.disposeBag)
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
extension NotificationController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.rx_data.value.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = viewModel.rx_data.value[indexPath.row]
        let height = model.cellHeight ?? 10
        
        return 58 + height
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.notificationCenterIdentifier.identifier, for: indexPath) as! NotifactionCell
    
        cell.model = viewModel.rx_data.value[indexPath.row]
        return cell
    }
    
}
