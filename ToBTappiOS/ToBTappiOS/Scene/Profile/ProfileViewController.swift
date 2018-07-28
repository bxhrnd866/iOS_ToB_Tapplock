//
//  ProfileViewController.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/14.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import Kingfisher
class ProfileViewController: BaseViewController {

    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var sexLab: UILabel!
    
    @IBOutlet weak var phoneNum: UILabel!
    
    @IBOutlet weak var mailNum: UILabel!
    
    @IBOutlet weak var headerImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfigModel.default.user.asDriver().filter {
            $0 != nil
            }.drive(onNext: { [weak self] user in
               
                self?.firstName.text = user?.firstName
                self?.lastName.text = user?.lastName
                self?.sexLab.text = user?.sex == 0 ? "Male" : "Famale"
                self?.phoneNum.text = user?.phone
                self?.mailNum.text = user?.mail
                
                if user?.photoUrl != nil, let url = URL(string: (user?.photoUrl)!) {
                    self?.headerImg.kf.setImage(with: ImageResource.init(downloadURL: url), options: [.processor(kfProcessor)])
                }
                
            }).disposed(by: rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImageUrl(_ url: String) {
        plog(url)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let imagePicker = R.segue.profileViewController.showImagepickerIdentifier(segue: segue) {
            imagePicker.destination.topViewController = self
            imagePicker.destination.uploader = RegisterUserImageUploader.init(callback: self.setImageUrl)
        }
    }
}
