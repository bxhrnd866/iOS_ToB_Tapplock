//
//  PeripheralEncrypt.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/6/21.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import Foundation
import CryptoSwift

extension PeripheralModel {
    
    func randomKeyServeEncrpted(numer: String) {
        
        provider.rx.request(APIServer.macforAnylock(mac: peripheral.mac!, randNum: numer))
            .mapObject(APIResponse<TapplockModel>.self)
            .subscribe(onSuccess: { [weak self] response in
                
                if response.success {
                    guard let data = response.data else { return }
                 
                    self?.key1 = data.key1!
                    self?.serialNo = data.serialNo!

                    self?.id = data.id
                    self?.morseStatus = data.morseStatus
                    self?.lockStatus = data.lockStatus
                    
                    
//                    self?.secretKey = data.authKey!.hexadecimal()
                    
//                    let hex = self?.encrpted(data: numer.hexadecimal()).hexadecimal()
//                    if let new = hex {
//                        self?.sendVerifyRandom(numer: new[0...23])
//                    }
                    
                    self?.sendPairingCommand()
                } else {
                    plog(response.codeMessage)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    // 命令加密
    public func writeEncryptedData(data: Data) {
        
        if secretKey == nil { 
            plog("老版本不加密")
            peripheral.writeValue(data, for: writeCharacteristic!, type: .withResponse)
            return
        }
        
        let hex = encrpted(data: data)
        
        if hex.count <= 20{
            plog("短加密==\(data.toHexString())")
            peripheral.writeValue(hex, for: writeCharacteristic!, type: .withResponse)
            return
        }
        
        let vl = hex.hexadecimal().inserting(separator: ",", every: 32)
        var value = vl.components(separatedBy: ",")
        
        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(10))
        codeTimer.setEventHandler(handler: {
            
            self.peripheral.writeValue(value[0].hexadecimal(), for: self.writeCharacteristic!, type: .withResponse)
            value.remove(at: 0)
            if value.count == 0 {
                codeTimer.cancel()
            }
        })
        codeTimer.resume()
    }
    
    public func responseDecrypted(data: Data) {
        let response = self.decrypt(data: data)
        setResponse(data: response)
        plog(response.hexadecimal())
    }
    
    // 加密
    func encrpted(data: Data) -> Data {
        let encrypted = try! AES(key: secretKey.bytes, blockMode: .ECB, padding: Padding.pkcs5).encrypt((data.bytes))
        return Data(encrypted)
    }
    // 解密
    func decrypt(data: Data) -> Data {
        let decrypt = try! AES(key: secretKey.bytes, blockMode: .ECB, padding: Padding.pkcs5).decrypt(data.bytes)
        return Data(decrypt)
    }
   
    
}





