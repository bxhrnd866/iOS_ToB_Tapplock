//
//  AppDelegate+Method.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/3.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import CFAlertViewController

extension AppDelegate {
    func checkVersion() {
//
//        //网络请求获取并比较版本信息.
//        _ = provider.rx.request(APIService.SupportVersion)
//            .mapObject(APIResponse<SupportVersionModel>.self)
//            .subscribe(onSuccess: { [weak self] response in
//                if response.data == nil {
//                    return
//                }
//                let app_Version: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//
//
//
//                //当前版本低于最低版本时,强制升级
//                //V2.0使用minVersionName字段可识别float数,之后版本使用minVersionCode可识别多位版本号
//                if response.data!.minVersionCode!.compare(app_Version) == .orderedDescending {
//
//                    //                    if (Float(response.data!.minVersionName!)! > Float(app_Version)!) {
//                    let alertController = CFAlertViewController(title: nil,
//                                                                message: R.string.localizable.mustUpdateMessage(),
//                                                                textAlignment: .left,
//                                                                preferredStyle: .alert,
//                                                                didDismissAlertHandler: nil)
//                    let okAction = CFAlertAction(title: R.string.localizable.oK(),
//                                                 style: .Default,
//                                                 alignment: .justified,
//                                                 backgroundColor: UIColor.themeColor,
//                                                 textColor: nil,
//                                                 handler: { _ in
//                                                    if #available(iOS 10.0, *) {
//                                                        UIApplication.shared.open(URL.init(string: "itms-apps://itunes.apple.com/us/app/tapplock/id1166207296?mt=8")!)
//
//                                                    } else {
//                                                        // Fallback on earlier versions
//                                                    }
//
//                    })
//                    alertController.addAction(okAction)
//                    alertController.shouldDismissOnBackgroundTap = false
//                    alertController.backgroundStyle = .blur
//                    alertController.backgroundColor = UIColor.clear
//
//
//                    if let presnt = self?.window?.rootViewController?.presentedViewController {
//                        presnt.present(alertController, animated: true, completion: nil)
//                    } else {
//                        self?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
//                    }
//
//                }
//
//                    //当前版本低于最高版本时,推荐升级
//                    //V2.0使用maxVersionName字段可识别float数,之后版本使用maxVersionCode可识别多位版本号
//
//                else if  response.data!.maxVersionCode!.compare(app_Version) == .orderedDescending {
//
//                    let alertController = CFAlertViewController(title: nil,
//                                                                message: R.string.localizable.canUpdateMessage(),
//                                                                textAlignment: .left,
//                                                                preferredStyle: .alert,
//                                                                didDismissAlertHandler: nil)
//                    let okAction = CFAlertAction(title: R.string.localizable.yes(),
//                                                 style: .Default,
//                                                 alignment: .justified,
//                                                 backgroundColor: UIColor.themeColor,
//                                                 textColor: nil,
//                                                 handler: { _ in
//                                                    if #available(iOS 10.0, *) {
//                                                        UIApplication.shared.open(URL.init(string: "itms-apps://itunes.apple.com/us/app/tapplock/id1166207296?mt=8")!)
//                                                    } else {
//                                                        // Fallback on earlier versions
//                                                    }
//
//                    })
//                    alertController.addAction(okAction)
//
//                    let noAction = CFAlertAction(title: R.string.localizable.no(),
//                                                 style: .Default,
//                                                 alignment: .justified,
//                                                 backgroundColor: UIColor.themeColor,
//                                                 textColor: nil,
//                                                 handler: nil)
//                    alertController.addAction(noAction)
//                    alertController.shouldDismissOnBackgroundTap = false
//                    alertController.backgroundStyle = .blur
//                    alertController.backgroundColor = UIColor.clear
//                    if let presnt = self?.window?.rootViewController?.presentedViewController {
//                        presnt.present(alertController, animated: true, completion: nil)
//                    } else {
//                        self?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
//                    }
//                } else {
//
//                }
//
//            })
        
    }
    
    

}
