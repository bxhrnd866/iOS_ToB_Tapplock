//
//  BLEUpdate.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/31.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa
import CFAlertViewController
class BLEUpdate: NSObject {
    
    weak var peripheral: PeripheralModel?
    
    private var uploadFinger = [FingerprintDataModel]()
    private var deleteFinger = [FingerprintDataModel]()
    private var updateApis = [FingerprintDataModel]()
    
    init(_ peripheral: PeripheralModel) {
        super.init()
        
        self.peripheral = peripheral
        peripheral.rx_response.asObservable()
            .subscribe(onNext: { [weak self] response in
                
                switch response {
                case .EnrollFingerprint(_):
                    if response.success {
                        self?.updateApis.append((self?.uploadFinger[0])!)
                        self?.uploadFinger.remove(at: 0)
                        if self?.uploadFinger.count == 0 {
                            self?.updatefingerprintSyncState(syncType: 0)
                        } else {
                            self?.startEnrrol()
                        }
                        
                    } else {
                        self?.updatefingerprintSyncState(syncType: 0)
                    }
                    
                case .DeleteFingerprint(_):
                   
                    if response.success {
                        self?.updateApis.append((self?.deleteFinger[0])!)
                        self?.deleteFinger.remove(at: 0)
                        if self?.deleteFinger.count == 0 {
                            self?.updatefingerprintSyncState(syncType: 1)
                        } else {
                            self?.deleteFingerprint()
                        }
                        
                    } else {
                        self?.updatefingerprintSyncState(syncType: 1)
                    }
                case .MorseCode(_):
                     SyncView.instance.rx_hidden.value = true
                    if response.success {
                        
                        self?.updateMorseStatus()
                    }
                case .FactoryReset(_):
                    if response.success {
                        self?.deleteLockAPI()
                    }
                case .Unlock(_):
                    if response.success {
                        if self?.peripheral?.lockStatus == -1 {
                            self?.peripheral?.sendRestCommand()
                        }
                    }
                default:
                    break
                }
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    // 更新指纹
    func startEnrrol() {
//        let finger = uploadFinger[0].templateData?.inserting(separator: ",", every: 8)
//        if finger != nil {
//            let source = finger!.components(separatedBy: ",")
//            self.updateFingerprint(fingers: source)
//        }
        
    }
    
    
    func updateFingerprint(fingers: [String]) {
        var data = fingers
        
        peripheral?.sendStartFingerprint()
        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(10))
        codeTimer.setEventHandler(handler: {
            
            self.peripheral?.sendFingerPrintData(data: data[0])
            data.remove(at: 0)
            if data.count == 0 {
                codeTimer.cancel()
            }
        })
        codeTimer.resume()
    }
    
    // 删除指纹
    func deleteFingerprint() {
        let index = deleteFinger[0]
        if index.lockFingerprintIndex != nil {
            peripheral?.sendDeleteFingerprintCommand(index: index.lockFingerprintIndex!)
        }
    }
    // 删除锁
    func deleteLock()  {
        self.peripheral?.sendUnlockCommand()
    }
}

extension BLEUpdate {   // API 相关
    // 获取指纹
    func loadAPI() {
        provider.rx.request(APIServer.downloadFingerprint(lockId: (peripheral?.id)!))
            .mapObject(APIResponseData<FingerprintDataModel>.self)
            .subscribe(onSuccess: { [weak self] response in

                // 0 下载 1 删除
                if response.success {
                    guard let data = response.data else { return }
                    _ = data.map {
                        if $0.syncType == 0 {
                            self?.uploadFinger.append($0)
                        } else {
                            self?.deleteFinger.append($0)
                        }
                    }

                    if self?.deleteFinger.count != 0 {
                        self?.deleteFingerprint()
                    } else {
                        self?.startEnrrol()
                    }
                } else {
                    // 错误信息
                     SyncView.instance.rx_hidden.value = true
                }
            }).disposed(by: rx.disposeBag)
    }
    
    // 更新锁指纹同步完成
    func updatefingerprintSyncState(syncType: Int) {
        updateApis.removeAll()
        var arr = [Any]()
        for model in updateApis {
            
            var dict = [String : Any]()
            if model.fingerprintId != nil {
                dict = dict + ["fingerprintId": model.fingerprintId!]
            }
            
            if model.lockFingerprintIndex != nil {
                dict = dict + ["fingerprintId": model.lockFingerprintIndex!]
            }
            if model.lockId != nil {
                dict = dict + ["lockId": model.lockId!]
            }
            dict = dict + ["syncType": syncType]
            arr.append(dict)
        }
        
        provider.rx.request(APIServer.updateFingerprintSycnState(relSyncStatusUpdateBOList: arr))
            .mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { [weak self] response in
                
                if response.success {
    
                    
                    if syncType == 1 {
                        
                        if (self?.uploadFinger.count)! > 0 {
                            self?.startEnrrol()
                        } else if self?.peripheral?.morseStatus == 1 {
                            self?.downloadMorseCode()
                        } else {
                            SyncView.instance.rx_hidden.value = true
                        }
                        
                    } else {
                        if self?.peripheral?.morseStatus == 1 {
                            self?.downloadMorseCode()
                        } else {
                            SyncView.instance.rx_hidden.value = true
                        }
                    }
                    
                } else {
                    plog(response.codeMessage)
                    SyncView.instance.rx_hidden.value = true
                }
            
        }).disposed(by: rx.disposeBag)
        
    }
    // 更新锁信息
    func updateLockInfor() {
        // 更新锁信息 位置 电量
        let lat = ConfigModel.default.locaiton?.location?.coordinate.latitude
        let long = ConfigModel.default.locaiton?.location?.coordinate.longitude
        
        provider.rx.request(APIServer.updateLock(battery: String((peripheral!.rx_battery.value)!),
                                                 firmwareVersion: nil,
                                                 hardwareVersion: peripheral?.rx_hardware.value,
                                                 id: (peripheral?.id)!,
                                                 latitude: String(lat!),
                                                 longitude: String(long!),
                                                 lockName: nil, morseCode: nil, morseStatus: nil, syncTypes: [0,1,2]))
            .mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { response in
                
                if !response.success {
                    plog(response.codeMessage)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    // 删除锁API
    func deleteLockAPI() {
        
        provider.rx.request(APIServer.deleteLocks(id: (peripheral?.id)!))
            .mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { [weak self] response in
                if response.success {
                    // 删除锁成功
                } else {
                    // 删除失败
                }
            }).disposed(by: rx.disposeBag)
    }
    
    // 下载指纹摩斯码
    func downloadMorseCode() {
        provider.rx.request(APIServer.downloadMorsecode(id: (peripheral?.id)!))
            .mapObject(APIResponseString.self)
            .subscribe(onSuccess: { [weak self] response in
                if response.success {
                    if response.data != nil {
                        self?.peripheral?.sendMorseCodeCommand(code: response.data!)
                    } else {
                         SyncView.instance.rx_hidden.value = true
                    }
                }
        }).disposed(by: rx.disposeBag)
    }
    // 更新摩斯码状态
    func updateMorseStatus() {
        provider.rx.request(APIServer.updateLock(battery: nil,
                                                 firmwareVersion: nil,
                                                 hardwareVersion: nil,
                                                 id: (peripheral?.id)!,
                                                 latitude: nil,
                                                 longitude: nil,
                                                 lockName: nil, morseCode: nil, morseStatus: 1, syncTypes: [2]))
            .mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { response in
                
                if !response.success {
                    plog(response.codeMessage)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    
    
    func showTotals() {
        SyncView.instance.rx_hidden.value = false
        let window = UIApplication.shared.delegate?.window!
        let x =  window?.rootViewController?.presentedViewController
        
        let alertController = CFAlertViewController(title: "有数据需要同步",
                                                    message: nil,
                                                    textAlignment: .left,
                                                    preferredStyle: .alert,
                                                    didDismissAlertHandler: nil)
        alertController.shouldDismissOnBackgroundTap = false
        alertController.backgroundStyle = .blur
        alertController.backgroundColor = UIColor.clear
        
        let ok = CFAlertAction(title: R.string.localizable.oK(), style: .Default, alignment: .justified, backgroundColor: UIColor.themeColor, textColor: nil, handler: nil)
        
        alertController.addAction(ok)
        x?.present(alertController, animated: true, completion: nil)
    }
    
}



