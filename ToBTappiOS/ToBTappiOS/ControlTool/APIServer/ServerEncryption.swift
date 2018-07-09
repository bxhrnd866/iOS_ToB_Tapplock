//
//  ServerEncryption.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/9.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
import CryptoSwift
// MARK: API加密
private let hmacSecret = "BBBFAD816B60C75EF3FBFB3859900E753BDED7FDCC9BCDB91D20CE999A0C0EE66952CBEF64E50999D71F83567714FBB6FE4A7B01C2CBDF8ADF1EEA4D460DEAE0"

private let aesSecret = "tprjrA5kkKyvh4nw"

private let aes = try! AES(key: aesSecret.bytes, blockMode: .ECB, padding: Padding.pkcs5)


extension ServerAPI {
    
    // 签名
    func hmacSign() -> [String: String] {
        
        let time = Date().timeStemp
        let random = randomNumer()
        let body =  time + ":" + random
        let signature = try! HMAC.init(key: hmacSecret.bytes, variant: .sha256).authenticate(body.bytes)
        
        let dict = ["timestamp": time, "rand": random, "signature": signature.toHexString()]
        
        return dict
    }
    
    func randomNumer() -> String {
        var num = ""
        for _ in 0...7 {
            num += String(arc4random_uniform(10))
        }
        return num
    }
    
    // body字典加密
    func requestBodyEncrypted(body: [String: Any]) -> Data {
        let data = try? JSONSerialization.data(withJSONObject: body, options: [])
        return data!
        
        let json = String(data: data!, encoding: String.Encoding.utf8)
        let encrypted = try! aes.encrypt((json!.bytes))
        let js = Data(encrypted).base64EncodedString()
        let da = js.data(using: .utf8)
        return da!
    }
}
