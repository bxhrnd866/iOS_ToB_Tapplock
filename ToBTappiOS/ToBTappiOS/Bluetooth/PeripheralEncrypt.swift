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
        _ = provider.rx.request(ApiService.GenerateLockKey(numer: numer, lockid: self.peripheral.lockId)).mapObject(APIResponseString.self).subscribe(onSuccess: { [weak self] response in
            if let key = response.data {
                self?.secretKey = key.hexadecimal()
                let data = numer.hexadecimal()
                let hex = self?.encrpted(data: data!).hexadecimal()
                self?.sendVerifyRandom(numer: (hex![0...23]))
            }
        })
    }
   
    // 加密
    func encrpted(data: Data) -> Data {
        let encrypted = try! AES(key: (secretKey?.bytes)!, blockMode: .ECB, padding: Padding.pkcs5).encrypt((data.bytes))
        return Data(encrypted)
    }
    // 解密
    func decrypt(data: Data) -> Data {
        let decrypt = try! AES(key: self.secretKey!.bytes, blockMode: .ECB, padding: Padding.pkcs5).decrypt(data.bytes)
        return Data(decrypt)
    }

    // 命令加密
    func writeEncryptedData(data: Data) {
        
        if secretKey == nil {  //
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
        self.secretSource = vl.components(separatedBy: ",")
        //分开发送
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.02), target: self, selector: #selector(timeMethod), userInfo: nil, repeats: true)
    }
    
    
    @objc func timeMethod() {
        
        let comand = self.secretSource.first as! String
        peripheral.writeValue(comand.hexadecimal(), for: writeCharacteristic!, type: .withResponse)
        
        let x = self.decrypt(data: comand.hexadecimal())
        plog("长加密\(x.hexadecimal())")
        self.secretSource.remove(at: 0)
        if self.secretSource.count == 0 {
            endTimer()
        }
    }
    
    func endTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    func responseDecrypted(data: Data) {
        let response = self.decrypt(data: data)
        plog(response.hexadecimal())
        if self.dataLength == 0 {
            
            let hex = response.hexadecimal()
            let cmd = hex[0...5]
            if cmd == "aa55d0" {
                
                if let length = hex[8...9].toInt(), length > 0 {
        
                    self.dataLength = length
                    plog(self.dataLength)
                    self.historyString = hex
                    TL1History()
                }
                
            } else{
                setResponse(data: response)
            }
        } else {
            self.historyString = self.historyString! + response.hexadecimal()
            plog(self.historyString)
            TL1History()
        }

    }
    
    func TL1History() {
        if self.dataLength == 4 {
            let conotent = self.historyString![12...(self.historyString?.count)! - 3]
            plog("\(conotent)-----\(conotent.length/4)----\(self.dataLength)")
            TL1Update(value: conotent)
            self.dataLength = 0
            self.historyString = nil
        } else {
            let conotent = self.historyString![12...(self.historyString?.count)! - 5]
            plog("\(conotent)-----\(conotent.length/4)----\(self.dataLength)")
            if conotent.length / 4 == self.dataLength {
                TL1Update(value: conotent)
                self.dataLength = 0
                self.historyString = nil
            }
            
        }
       
    }
   
    
}





