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
    var updateModel: FirmwareModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        updateContent.text = updateModel.updateContent
        
        introuceLab.text = "\(R.string.localizable.newfirmwareversion()): \(updateModel.currentVersion ?? "") | \(updateModel.firmwareSize ?? "")"
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification(notification:)), name: NSNotification.Name(rawValue: notificaitonName_postDFUUpate), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionSelect(_ sender: Any) {
        
        self.performSegue(withIdentifier: R.segue.updateDFUController.showUpdateLoading, sender: self)
    }
    
    @objc func notification(notification: Notification) {
        let obj = notification.object as! UpdateStatus
        
        if obj != .downfail {
            self.navigationController?.popViewController(animated: true)
        }
    }
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let upvc = R.segue.updateDFUController.showUpdateLoading(segue: segue) {
            upvc.destination.viewModel.downloadUrl = updateModel.firmwarePackageUrl
        }
    }


}
