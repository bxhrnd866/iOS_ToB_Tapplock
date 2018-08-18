//
//  CpageViewController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/8/18.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class CpageViewController: UIViewController {

    @IBOutlet weak var heightContant: NSLayoutConstraint!
    var block: (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if mScreenW <= 320 {
            self.heightContant.constant = 250
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectAction(_ sender: Any) {
        if self.block != nil {
            self.block!()
        }
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
