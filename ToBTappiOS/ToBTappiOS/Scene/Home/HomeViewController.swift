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
import Reachability
class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.addMenuView()
        
        self.performSegue(withIdentifier: R.segue.homeViewController.pushMyTapplock, sender: self)
        
        delegate.menuView!.rx_SelectIndex.asDriver()
            .drive(onNext: { [weak self] index in
                
                let model = delegate.menuView!.viewModel.rx_list.value[index]
                switch model.text {
                case R.string.localizable.menuProfile():
                    self?.performSegue(withIdentifier: R.segue.homeViewController.pushProfile, sender: self)
                    self?.navigationChildController()
                case R.string.localizable.menuTapplock():
                    
                    var child = self?.navigationController?.viewControllers
                    if (child?.count)! == 2 {
                        return
                    }
                    if (child?.count)! == 3 {
                        child?.remove(at: 2)
                        self?.navigationController?.viewControllers = child!
                    }
                case R.string.localizable.menuViewAllLocks():
                    self?.performSegue(withIdentifier: R.segue.homeViewController.pushViewAlllock, sender: self)
                    self?.navigationChildController()
                case R.string.localizable.menuViewHistory():
                    self?.performSegue(withIdentifier: R.segue.homeViewController.pushViewHistory, sender: self)
                    self?.navigationChildController()
                case R.string.localizable.menuNotification():
                    self?.performSegue(withIdentifier: R.segue.homeViewController.showNotification, sender: self)
                    self?.navigationChildController()
                case R.string.localizable.menuTutorial():
                    self?.performSegue(withIdentifier: R.segue.homeViewController.pushTutorial, sender: self)
                    self?.navigationChildController()
                case R.string.localizable.menuSetting():
                    self?.performSegue(withIdentifier: R.segue.homeViewController.pushSetting, sender: self)
                    self?.navigationChildController()
                case R.string.localizable.menuLogout():
                    self?.logOut()
                
                default:
                    break
                }
                

        }).disposed(by: rx.disposeBag)
        
        delegate.menuView!.rx_logout.asDriver().drive(onNext: { [weak self] bl in
            if bl {
                self?.logOut()
            }
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
                                        let delegate = UIApplication.shared.delegate as! AppDelegate
                                        delegate.removeMenuView()
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ConfigModel.default.deleteToken()
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
