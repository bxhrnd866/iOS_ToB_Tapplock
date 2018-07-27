//
//  UpdateDFUController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/26.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class UpdateDFUController: UIViewController {
    @IBOutlet weak var introuceLab: UILabel!
    @IBOutlet weak var updateContent: UILabel!
//    var updateModel: UpdateFWModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionSelect(_ sender: Any) {
        
        self.performSegue(withIdentifier: R.segue.updateDFUController.showUpdateLoading, sender: self)
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
