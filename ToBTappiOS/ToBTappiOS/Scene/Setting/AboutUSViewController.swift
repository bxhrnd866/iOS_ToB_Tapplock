//
//  AboutUSViewController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/6.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class AboutUSViewController: UIViewController {

    @IBOutlet weak var versionLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let app_Version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        self.versionLab.text = app_Version

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
