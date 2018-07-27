//
//  UpdateLoadingController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/26.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class UpdateLoadingController: UIViewController {

    @IBOutlet weak var statusLab: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var progressLab: UILabel!
    
    let viewModel = DFUViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
