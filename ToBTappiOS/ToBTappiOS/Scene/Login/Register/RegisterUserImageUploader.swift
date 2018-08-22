//
//  RegisterUserImageUploader.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/21.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import RxSwift
import WXImageCompress
import Cloudinary
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
        let params = CLDUploadRequestParams().setFolder("tapplock-b2b-ios")
        cloudinaryStorage.createUploader().upload(data: UIImagePNGRepresentation(image.wxCompress())!, uploadPreset: "eusqphao", params: params, progress: { (progress) in
            print(progress)
        }, completionHandler: { (result, error) in

            if error != nil {
                self.rx_sucess.value = false
            } else {
                self.rx_sucess.value = true
                
                self.callBack((result?.url)!)
                
            }
        })
        
        
        
        
        
        
        
    }



}




