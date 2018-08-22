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
                    
                case .FingerprintEnd(_):
                    if response.success {
                        plog("添加指纹成功 ----->\(response.fingerprintID)--\(response.value) ")
                        
                        
                        let md = self?.uploadFinger[0]
                        md?.lockFingerprintIndex = response.fingerprintID
                        self?.updateApis.append(md!)
                        self?.uploadFinger.remove(at: 0)
                        if self?.uploadFinger.count == 0 {
                            self?.updateSyncState()
                        } else {
                            self?.startEnrrol()
                        }
                        
                    } else {
                        plog("添加指纹失败")
                        self?.updateSyncState()
                    }
                    
                case .DeleteFingerprint(_):
                    self?.updateApis.append((self?.deleteFinger[0])!)
                    self?.deleteFinger.remove(at: 0)
                    if self?.deleteFinger.count == 0 {
                        if (self?.uploadFinger.count)! > 0 {
                            self?.startEnrrol()
                        } else {
                            self?.updateSyncState()
                        }
                        
                    } else {
                        self?.deleteFingerprint()
                    }
                    plog("已删除成功")
                  
                case .MorseCode(_):
                     SyncView.instance.rx_numers.value -= 1
                    if response.success {
                        self?.updateMorseStatus()
                    }
                case .FactoryReset(_):
                    if response.success {
                        self?.deleteLockAPI()
                    }
                case .Unlock(_):
                    
                    plog("解锁成功")
                    if response.success {
                        if self?.peripheral?.lockStatus == -1 {
                            self?.peripheral?.sendRestCommand()
                        }
                    }
                case .ClearMorseCode(_):
                    SyncView.instance.rx_numers.value -= 1
                    if response.success {
                        plog("删除morsecode 成功")
                        self?.updateMorseStatus()
                    }
                    
                default:
                    break
                }
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    
    public func updateLockState() {
        
        self.updateLockInfor()
        switch self.peripheral?.lockStatus {
        case 0:
            SyncView.instance.rx_numers.value += 1
            self.loadAPI()
        case 1:
            
            if self.peripheral?.morseStatus == 0 {
                 SyncView.instance.rx_numers.value += 1
                self.downloadMorseCode()
            }
            
            if self.peripheral?.morseStatus == -1 {
                plog("删除摩斯码")
                SyncView.instance.rx_numers.value += 1
                self.peripheral?.sendClearMorseCode()
            }
            
        case -1:
            self.deleteLock()
        default:
            break
        }
    }
    
    // 更新指纹
     fileprivate func startEnrrol() {
        plog(uploadFinger.count)
        
        if  uploadFinger.count == 0 {
            return
        }
        
        let finger = uploadFinger[0].templateData?.inserting(separator: ",", every: 16)
        if finger != nil {
            let source = finger!.components(separatedBy: ",")
            self.updateFingerprint(fingers: source)
        }
        
    }
    
    
    fileprivate func updateFingerprint(fingers: [String]) {
        var data = fingers
        
        peripheral?.sendStartFingerprint()
        var num = 0
        
        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(10))
        codeTimer.setEventHandler(handler: {
            
            var c = ""
            if data.count != 1 {
                let a = String(num).decimalConver()
                let b = a?.hexadecimalSupplement()
                c = b! + "0800" + data[0]
            } else {
                c = "3e0200" + data[0]
            }
            
            self.peripheral?.sendFingerPrintData(data: c)
            data.remove(at: 0)
            num = num + 1
            if data.count == 0 {
                self.peripheral?.sendEndFingerprint()
                codeTimer.cancel()
            }
        })
        codeTimer.resume()
    }
    
    // 删除指纹
    fileprivate func deleteFingerprint() {
        let index = deleteFinger[0]
        if index.lockFingerprintIndex != nil {
            peripheral?.sendDeleteFingerprintCommand(index: index.lockFingerprintIndex!)
        }
    }
    // 删除锁
     public func deleteLock()  {
        self.peripheral?.sendUnlockCommand()
    }
    
    
    
}

extension BLEUpdate {   // API 相关
    // 获取指纹
    fileprivate func loadAPI() {
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
                     SyncView.instance.rx_numers.value -= 1
                }
            }) { ( error) in
                SyncView.instance.rx_numers.value -= 1
            }.disposed(by: rx.disposeBag)
    }
    
    
     // 更新锁指纹同步完成
    fileprivate func updateSyncState() {
        var arr = [Any]()
        if updateApis.count == 0 {
            if self.peripheral?.morseStatus == 0 {
                plog("下载摩斯码")
                self.downloadMorseCode()
            } else if self.peripheral?.morseStatus == -1 {
                plog("删除摩斯码")
                self.peripheral?.sendClearMorseCode()
            } else {
                SyncView.instance.rx_numers.value -= 1
            }
            return
        }
        
        for model in updateApis {
            var dict = [String : Any]()
            if model.fingerprintId != nil {
                dict = dict + ["fingerprintId": model.fingerprintId!]
            }
            
            if model.lockFingerprintIndex != nil {
                dict = dict + ["lockFingerprintIndex": model.lockFingerprintIndex!]
            }
         
            if model.syncType != nil {
                dict = dict + ["syncType": model.syncType!]
            }
            
            dict = dict + ["lockId": (self.peripheral?.id)!]
            
            arr.append(dict)
        }
        
        updateApis.removeAll()
        
        
        provider.rx.request(APIServer.updateFingerprintSycnState(relSyncStatusUpdateBOList: arr))
            .mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { [weak self] response in
                
                if response.success {
                    if self?.peripheral?.morseStatus == 0 {
                        plog("下载摩斯码")
                        self?.downloadMorseCode()
                    } else if self?.peripheral?.morseStatus == -1 {
                        plog("删除摩斯码")
                        self?.peripheral?.sendClearMorseCode()
                    } else {
                         SyncView.instance.rx_numers.value -= 1
                    }
                   
                } else {
                   
                    SyncView.instance.rx_numers.value -= 1
                }
                
            }) { ( error) in
                SyncView.instance.rx_numers.value -= 1
            }.disposed(by: rx.disposeBag)
        
    }
    
    
   
  
    // 更新锁信息
    fileprivate func updateLockInfor() {
        // 更新锁信息 位置 电量
        let lat = ConfigModel.default.locaiton?.latitude
        let long = ConfigModel.default.locaiton?.longitude
        
        provider.rx.request(APIServer.updateLock(battery: String((peripheral!.rx_battery.value)!),
                                                 firmwareVersion: nil,
                                                 hardwareVersion: peripheral?.rx_hardware.value,
                                                 lockId: (peripheral?.id)!,
                                                 latitude: lat ?? "0",
                                                 longitude: long ?? "0",
                                                 location: ConfigModel.default.locaiton?.address,
                                                 lockName: nil,
                                                 morseCode: nil,
                                                 morseStatus: nil,
                                                 syncTypes: [0,2]))
            .mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { response in

                if !response.success {
                    plog(response.codeMessage)
                    
                }
            }).disposed(by: rx.disposeBag)
    }
    
  
    
    // 删除锁API
    fileprivate func deleteLockAPI() {
        plog("删除锁删除锁")
        provider.rx.request(APIServer.deleteLocks(id: (peripheral?.id)!))
            .mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { [weak self] response in
                if response.success {
                    // 删除锁成功
                    TapplockManager.default.rx_deleteLock.value = self?.peripheral?.rx_mac.value
                    
                } else {
                    // 删除失败
                }
            }) { ( error) in

            }.disposed(by: rx.disposeBag)
    }
    
    // 下载指纹摩斯码
    fileprivate func downloadMorseCode() {
        provider.rx.request(APIServer.downloadMorsecode(id: (peripheral?.id)!))
            .mapObject(APIResponseString.self)
            .subscribe(onSuccess: { [weak self] response in
                if response.success {
                    if response.data != nil {
                        self?.peripheral?.sendMorseCodeCommand(code: response.data!)
                    } else {
                         SyncView.instance.rx_numers.value -= 1
                    }
                }
            }) { ( error) in
                SyncView.instance.rx_numers.value -= 1
            }.disposed(by: rx.disposeBag)
    }
    // 更新摩斯码状态
    fileprivate func updateMorseStatus() {
        provider.rx.request(APIServer.updateLock(battery: nil,
                                                 firmwareVersion: nil,
                                                 hardwareVersion: nil,
                                                 lockId: (peripheral?.id)!,
                                                 latitude: nil,
                                                 longitude: nil,
                                                 location: nil,
                                                 lockName: nil, morseCode: nil, morseStatus: 1, syncTypes: [2]))
            .mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { response in
                
                if !response.success {
                    plog(response.codeMessage)
                    
                }
            }) { ( error) in
                
            }.disposed(by: rx.disposeBag)
    }
    
    
    func updateHistoryTime(close: Array<Any>, finger: Array<Any>, morese: Array<Any>) {
        
        var types = [3]
        
        if finger.count != 0 {
            types.append(1)
        }
        if morese.count != 0 {
            types.append(2)
        }
        
        provider.rx.request(APIServer.updateLockHistory(accessTypes: types, closeOperateTimes: close, latitude: nil, longitude: nil, location: nil, lockId: (self.peripheral?.id)!, morseOperateTimes: morese.count > 0 ? morese : nil, operateLocalDate: Date().string(custom: "yyyy-MM-dd"), unlockFingerprints: finger.count > 0 ? finger : nil, userId: nil)).mapObject(APIResponse<EmptyModel>.self)
            .subscribe(onSuccess: { [weak self] response in
                if response.success {
                    plog("上传历史成功")
                }
                self?.updateLockState()
            
            }) { [weak self] ( error) in
                self?.updateLockState()
            }.disposed(by: rx.disposeBag)
        
        
    }
    
    
    
  
}



