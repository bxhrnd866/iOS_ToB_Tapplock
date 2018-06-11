//
//  FileHelper.swift
//  test005
//
//  Created by TapplockiOS on 2018/5/15.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation
let fileManger = FileManager.default

extension FileManager {

    
    var homePath: String {
        return NSHomeDirectory()
    }
    
    var document: URL {
        let doc = fileManger.urls(for: .documentDirectory, in: .userDomainMask)
        return doc[0]
    }
    
    var cache: URL {
        let cac = fileManger.urls(for: .cachesDirectory, in: .userDomainMask)
        return cac[0]
    }
    
    // 创建文件
    func creatFolder(_ name: String) {
        let folder = self.cache.appendingPathComponent(name)
        let exist = fileManger.fileExists(atPath: folder.path)
        if !exist {
            try! fileManger.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        } else {
            print("文件已经存在")
        }
    }
    
    // 创建路径
    func creatPath(_ name: String, _ path: String?) -> String {
        if path != nil {
            return path! + "/" + name
        }
        return document.path + "/" + name
    }
    
    //移除路径
    public static func removfilePath(_ path: String) {
        if fileManger.fileExists(atPath: path) {
            do {
                try fileManger.removeItem(atPath: path)
            } catch let error {
                print(error)
            }
        } else {
            print("不存在的路径")
        }
    }
    // 获取文件大小
    func getfileSize(_ path: String) -> Int {
        var size: UInt64 = 0
        var isDir: ObjCBool = false
        let isExists = fileManger.fileExists(atPath: path, isDirectory: &isDir)
        if isExists {
            // 是否为文件夹
            if isDir.boolValue {
                // 迭代器 存放文件夹下的所有文件名
                let enumerator = fileManger.enumerator(atPath: path)
                for subPath in enumerator! {
                    // 获得全路径
                    let fullPath = path.appending("/\(subPath)")
                    do {
                        let attr = try fileManger.attributesOfItem(atPath: fullPath)
                        size += attr[FileAttributeKey.size] as! UInt64
                    } catch  {
                        print("error :\(error)")
                    }
                }
            } else {    // 单文件
                do {
                    let attr = try fileManger.attributesOfItem(atPath: path)
                    size += attr[FileAttributeKey.size] as! UInt64
                    
                } catch  {
                    print("error :\(error)")
                }
            }
        }
        return Int(size)
        
    }
    
    
    
    
    
    
    

}



//appendingPathComponent(_:)方法可以在路径后面追加一个新的路径，这个路径是一个字符串
//ppendingPathExtension(_:)在路径后面追加的新路径是一个扩展名 eg: txt
