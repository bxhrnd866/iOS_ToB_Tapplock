//
//  TutorialViewController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/8/18.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = R.segue.tutorialViewController.aPageControll(segue: segue) {
            vc.destination.block = { [weak self] in
                self?.scrollview.setContentOffset(CGPoint(x: mScreenW, y: 0), animated: true)
            }
        }
        if let vc = R.segue.tutorialViewController.bPageController(segue: segue) {
            vc.destination.block = { [weak self] in
                self?.scrollview.setContentOffset(CGPoint(x: 2 * mScreenW, y: 0), animated: true)
            }
        }
        if let vc = R.segue.tutorialViewController.cPageController(segue: segue) {
            vc.destination.block = { [weak self] in
                self?.dismissAction(true)
            }
        }
    }
 
    deinit {
        plog("xiaohui le")
    }

}
