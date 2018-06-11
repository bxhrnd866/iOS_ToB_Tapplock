//
//  RegisterUserImageUploader.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/21.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import RxSwift
//import WXImageCompress
//锁图片上传类==>图片选择器用
public protocol Uploader {
    var rx_sucess: Variable<Bool?> { get }
    func upload(image: UIImage)
    var rx_errorMessage: Variable<String?> { get }
    
    
}


//在图片选择器中进行注册时的头像上传
class RegisterUserImageUploader: NSObject, Uploader {
    var rx_sucess: Variable<Bool?> = Variable(nil)
    var rx_errorMessage: Variable<String?> = Variable(nil)
    var callBack: ((String) -> Void)

    //上传图片后的回掉
    init(callback: @escaping ((String) -> Void)) {
        callBack = callback
        super.init()

    }

    func upload(image: UIImage) {
//        cloudinaryStorage.createUploader().upload(data: UIImagePNGRepresentation(image.wxCompress())!, uploadPreset: "eusqphao", params: nil, progress: { (progress) in
//            print(progress)
//        }, completionHandler: { (result, error) in
//
//            if error != nil {
//                self.rx_sucess.value = false
//            } else {
//                self.rx_sucess.value = true
//                self.callBack((result?.url)!)
//            }
//        })
    }

    //用户信息上传接口
    func saveToApi(url: String) {
        _ = provider.rx.request(ApiService.EditUserConfiguration(mai: (ConfigModel.default.user.value?.mail)!, deviceToken: nil, firstName: nil, lastName: url, imageURL: nil, push: nil, showBattery: nil))
                .mapObject(APIResponse<UserModel>.self)
                .subscribe(onSuccess: { response in
                    if let user = response.data {
                        self.rx_sucess.value = true
                        
                        ConfigModel.default.user.value = user
                    } else if let errorMessage = response.message {
                        self.rx_errorMessage.value = errorMessage
                    }
                })
    }

}

