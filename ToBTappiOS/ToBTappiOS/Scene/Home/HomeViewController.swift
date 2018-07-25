//
//  HomeViewController.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/11.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CFAlertViewController
class HomeViewController: BaseViewController {

    @IBOutlet weak var myTapplcokView: UIView!
    @IBOutlet weak var profileView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let window = UIApplication.shared.delegate?.window!
        window?.addSubview(MenuView.instance)
        
        MenuView.instance.rx_SelectIndex.value = 1
        MenuView.instance.rx_logout.value = false
        
        MenuView.instance.rx_logout.asObservable().filter({ $0 != false }).subscribe(onNext: { [weak self] logout in
            self?.logOut()
        }).disposed(by: rx.disposeBag)
        
         self.performSegue(withIdentifier: R.segue.homeViewController.pushMyTapplock, sender: self)
        
        MenuView.instance.rx_SelectIndex.asObservable().subscribe(onNext: { [weak self] index in
            
            if index == 1 {
                var child = self?.navigationController?.viewControllers
                
                if (child?.count)! == 2 {
                    return
                }
                if (child?.count)! == 3 {
                    child?.remove(at: 2)
                    self?.navigationController?.viewControllers = child!
                    return
                }
            }
            if index == 0 {
                self?.performSegue(withIdentifier: R.segue.homeViewController.pushProfile, sender: self)
            } else if index == 2 {
                self?.performSegue(withIdentifier: R.segue.homeViewController.pushViewAlllock, sender: self)
            } else if index == 3 {
                self?.performSegue(withIdentifier: R.segue.homeViewController.pushViewHistory, sender: self)
            } else if index == 4 {
                self?.performSegue(withIdentifier: R.segue.homeViewController.pushTutorial, sender: self)
            } else if index == 5 {
                self?.performSegue(withIdentifier: R.segue.homeViewController.pushSetting, sender: self)
            }
            self?.navigationChildController()
            
        }).disposed(by: rx.disposeBag)
    }

    private func logOut() {
        let alertController = CFAlertViewController(title: nil,
                                                    message: R.string.localizable.ensureMessage_Logout(),
                                                    textAlignment: .left,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        let okAction = CFAlertAction(title: R.string.localizable.yes(),
                                     style: .Default,
                                     alignment: .justified,
                                     backgroundColor: UIColor.themeColor,
                                     textColor: nil,
                                     handler: { _ in
                                        ConfigModel.default.user.value = nil
                                        self.dismiss(animated: true)
        })
        alertController.addAction(okAction)
        
        let noAction = CFAlertAction(title: R.string.localizable.no(),
                                     style: .Default,
                                     alignment: .justified,
                                     backgroundColor: UIColor.themeColor,
                                     textColor: nil,
                                     handler: { _ in
                                        
        })
        alertController.addAction(noAction)
        alertController.shouldDismissOnBackgroundTap = false
        alertController.backgroundStyle = .blur
        alertController.backgroundColor = UIColor.clear
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 调整controllers
    func navigationChildController() {
        var child = self.navigationController?.viewControllers
        
        if (child?.count)! == 3 {
            return
        }
        child?.remove(at: 2)
        self.navigationController?.viewControllers = child!
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        plog("home dealloc")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
 

}
