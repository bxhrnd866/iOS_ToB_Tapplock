//
//  DFUViewModel.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/27.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import RxSwift
import iOSDFULibrary
import CoreBluetooth
enum UpdateStatus {
    case none
    case downloading
    case downSucess
    case downfail
    case updating
    case updateSucess
    case updatefail
}

class DFUViewModel: NSObject {
    
    var rx_step: Variable<UpdateStatus> = Variable(.none)
    var rx_progress: Variable<Float> = Variable(0.0)
    var dfuController: DFUServiceController?
    var dfuUrl: URL?
    var downloadUrl: String?
    var periphal: CBPeripheral?
    
    override init() {
        super.init()
        
        TapplockManager.default.rx_dfuLock.asObservable().filter({ $0 != nil }).map({ $0! }).subscribe(onNext: { [weak self] ble in
            self?.UpdateTapplockDFU(peropheral: ble)
            TapplockManager.default .rx_dfuLock.value = nil
        }).disposed(by: rx.disposeBag)
        

        NotificationCenter.default.addObserver(self, selector: #selector(enterBackgroundNotification), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc func enterBackgroundNotification() {
        
        if self.rx_step.value != .updateSucess {
            if self.periphal != nil {
                TapplockManager.default.manager.cancelPeripheralConnection(self.periphal!)
                
                self.dfuController?.pause()
                _ = dfuController?.abort()
            }
            
//            self.scanAgin()
            self.rx_step.value = .updatefail
        }
    }
    // 下载固件
    func downloadFirmware() {
        self.rx_step.value = .downloading
        DownloadManager.default.download(downloadUrl!).downloadProgress(progress: { [weak self] progress in
            self?.rx_progress.value = Float(progress)
        }).response { [weak self] result in

            switch result {
            case .success:
                self?.rx_step.value = .downSucess
                plog("下载成功")
                self?.rx_progress.value = 0
                guard let downurl = self?.downloadUrl else {
                    self?.rx_step.value = .downfail
                    return
                }
                self?.dfuUrl = DownloadManager.default.downloadFilePath(downurl)
                //                let xm = Bundle.main.path(forResource: "DFU_TAPP_X1003", ofType: "zip")
                //                let url = URL(fileURLWithPath: xm!)
                //                self?.dfuUrl = url
                self?.checkBlueWithAlert()
            default:
                plog("失败")
                self?.rx_step.value = .downfail
            }
        }

    }
    
    public func UpdateTapplockDFU(peropheral: CBPeripheral) -> Void {
        
        let firmware = DFUFirmware(urlToZipFile: self.dfuUrl!, type: .softdeviceBootloaderApplication)
        let initiator = DFUServiceInitiator(centralManager: TapplockManager.default.manager, target: peropheral)
        initiator.forceDfu = false
        initiator.packetReceiptNotificationParameter = 12
        initiator.logger =  self
        initiator.delegate = self
        initiator.progressDelegate = self
        initiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true
        dfuController = initiator.with(firmware: firmware!).start()

        self.periphal = peropheral
//
        
    }
    
    func updateFireware() -> Void {
        self.rx_step.value = .updating
        TapplockManager.default.editingLock?.peripheralModel?.sendEnterIntoDFU()
        TapplockManager.default.manager.stopScan()
    }

    func sendDFUUpatestate(update: UpdateStatus) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificaitonName_postDFUUpate), object: update, userInfo: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    func checkBlueWithAlert() {
        if  TapplockManager.default.editingLock?.peripheralModel?.rx_status.value != .connected {
            
            self.downloadUrl = nil
            self.rx_step.value = .updatefail
        } else {
            self.updateFireware()
        }
    }
}
// DFU代理

extension DFUViewModel: DFUServiceDelegate,DFUProgressDelegate,LoggerDelegate {
    
    //MARK: - LoggerDelegate
    func logWith(_ level: LogLevel, message: String) {
        var levelString : String?
        switch(level) {
        case .application:
            levelString = "Application"
        case .debug:
            levelString = "Debug"
        case .error:
            levelString = "Error"
        case .info:
            levelString = "Info"
        case .verbose:
            levelString = "Verbose"
        case .warning:
            levelString = "Warning"
            scanAgin()
            self.rx_step.value = .updatefail
        }
        plog("\(levelString!): \(message)")
    }
    //MARK: - DFUServiceDelegate
    func dfuStateDidChange(to state: DFUState) {
        switch state {
        case .connecting:
            plog("Connecting...")
        case .starting:
            
            plog("Starting DFU...")
            
        case .enablingDfuMode:
            
            plog("Enabling DFU Bootloader...")
            
        case .uploading:
            
            plog("Uploading...")
        case .validating:
            
            plog("Validating...")
        case .disconnecting:
            
            plog("Disconnecting...")
        case .completed:
            plog("Upload complete")

            FileManager.removeFileUrl(url: self.dfuUrl!)
            
            self.rx_step.value = .updateSucess
            
            scanAgin()
            
        case .aborted:
            plog("Upload aborted")
            scanAgin()
            self.rx_step.value = .updatefail
        }
        
        
    }
    
    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        DispatchQueue.main.async {
            print("Error: \(message)")
            
        }
        scanAgin()
    
        
        self.rx_step.value = .updatefail
    }
    //MARK: - DFUProgressDelegate
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        print(Float(progress) / 100.0)
        let fx = Float(progress) / 100.0
        self.rx_progress.value = fx
    }
    
    
    func scanAgin() {
        TapplockManager.default.reInitManager()
        TapplockManager.default.scan()
        self.downloadUrl = nil
        self.dfuController = nil
    }

}

