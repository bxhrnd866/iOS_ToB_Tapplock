//
//  CameraCell.swift
//  Tapplock2
//
//  Created by Jiang Xiaoming on 2017/12/12.
//  Copyright © 2017年 Tapplock. All rights reserved.
//

import UIKit
import AVFoundation

//自定义控件Storyboard用
class CameraCell: UICollectionViewCell {
    @IBOutlet weak var view: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        if Platform.isSimulator {
        } else {
            let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if authStatus == .authorized {
                //多线程执行, 启动相机耗时巨大
                DispatchQueue.global().async() {
                    let session = AVCaptureSession.init()
                    session.sessionPreset = .low
                    let device = AVCaptureDevice.default(for: .video)
                    let input = try! AVCaptureDeviceInput.init(device: device!)
                    session.addInput(input)

                    DispatchQueue.main.async() {
                        let layer = AVCaptureVideoPreviewLayer.init(session: session)
                        layer.videoGravity = .resizeAspectFill
                        layer.frame = self.view.bounds
                        self.view.layer.addSublayer(layer)
                        session.startRunning()
                    }
                }
            }
        }
    }
}
