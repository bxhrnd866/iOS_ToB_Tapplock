//
//  HistoryDateController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/25.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class HistoryDateController: UIViewController {

    @IBOutlet weak var endBG: UIView!
    @IBOutlet weak var startBG: UIView!
    
    @IBOutlet weak var startLab: UILabel!
    @IBOutlet weak var startTime: UILabel!
    
    @IBOutlet weak var endLab: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var DateBtn: UIButton!
    @IBOutlet weak var TimeBtn: UIButton!
    
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var TimeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
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
