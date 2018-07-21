//
//  BaseNaviController.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/10.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class BaseNaviController: UINavigationController {

    var serch: SearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        serch = SearchBar(frame: CGRect(x: 0, y: 0, width: mScreenW, height: 44))
        self.navigationBar.addSubview(serch)
        
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
