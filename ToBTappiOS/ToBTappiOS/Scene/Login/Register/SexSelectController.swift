//
//  SexSelectController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/12.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class SexSelectController: UIViewController {

    var block:(((String, Int))->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sexSelectAction(_ sender: Any) {
        if self.block != nil {
            let btn = sender as! UIButton
            let index = btn.tag - 1000
            self.block!(((btn.titleLabel?.text)!, index))
            self.dismiss(animated: true, completion: nil)
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
