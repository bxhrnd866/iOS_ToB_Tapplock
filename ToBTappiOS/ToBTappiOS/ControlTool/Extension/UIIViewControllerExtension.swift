//
//  UIIViewControllerExtension.swift
//  ToBTapplcok
//
//  Created by TapplockiOS on 2018/4/10.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import UIKit
import CFAlertViewController

var topViewControllerKey = "topViewControllerKey"
extension UIViewController {
    //Storyboard用Pop动作
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //Storyboard用dismiss动作
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    
    //页面按钮点击时,检查蓝牙状态
    func checkBlueWithAlert() -> Bool {
        if TapplockManager.default.bluetoothState != .poweredOn {
            self.showToast(message: "R.string.localizable.errorMessage_BluetoothOff()")
            return false
        } else if TapplockManager.default.isEditLock?.peripheral?.rx_staus.value == .connected {
            self.showToast(message: "R.string.localizable.errorMessage_LockDisconnected()")
            TapplockManager.default.scan()
            return false
        } else {
            return true
        }
    }
    func showToast(message: String, didDismiss: ((Any) -> Void)? = nil) {
        let alertController = CFAlertViewController(title: message,
                                                    message: nil,
                                                    textAlignment: .left,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        alertController.shouldDismissOnBackgroundTap = false
        alertController.backgroundStyle = .blur
        alertController.backgroundColor = UIColor.clear

        let okAction = CFAlertAction(title: "R.string.localizable.oK()",
                                     style: .Default,
                                     alignment: .justified,
                                     backgroundColor: thembColor,
                                     textColor: nil,
                                     handler: didDismiss)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

    var topViewController: UIViewController? {
        get {
            return (objc_getAssociatedObject(self, &topViewControllerKey) as? UIViewController)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &topViewControllerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func popToController(controller: AnyClass) {
        for vc in (self.navigationController?.viewControllers)! {
            if vc.isKind(of: controller) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
}
