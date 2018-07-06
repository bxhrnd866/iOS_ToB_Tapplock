//
//  LockDetailController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class LockDetailController: UIViewController {

    @IBOutlet weak var bgview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgview.layer.shadowColor = UIColor.shadowColor.cgColor
        self.bgview.layer.shadowOffset = CGSize(width: 4, height: 7)
        self.bgview.layer.shadowOpacity = 0.7
        self.bgview.layer.shadowRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
