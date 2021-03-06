//
//  TutorialController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/5.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import WebKit
class TutorialController: UIViewController {

    var wbView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wbView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        self.view.addSubview(self.wbView!)
    
        let mainb = Bundle.main.bundlePath + "/html"
        
        let url = URL(fileURLWithPath: mainb)
        
        let htmlpath = "\(mainb)/phone.html"
        
        let ml = try? String(contentsOfFile: htmlpath, encoding: String.Encoding.utf8)
        
        if ml != nil {
            self.wbView?.loadHTMLString(ml!, baseURL: url)
        }
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
