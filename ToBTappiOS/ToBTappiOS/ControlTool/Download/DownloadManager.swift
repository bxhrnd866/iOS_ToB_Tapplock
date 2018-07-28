//
//  DownloadManager.swift
//  SwiftLib
//
//  Created by nb616 on 2017/10/19.
//  Copyright © 2017年 nb616. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
let downloadFolder = "Download"
class DownloadManager {
    static let `default` = DownloadManager()
    /** 下载任务管理*/
    fileprivate var downloadTasks = [String: DownloadTaskManager]()
    
    func download(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DownloadTaskManager {
        let taskManager = DownloadTaskManager()
        taskManager.download(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        downloadTasks[url] = taskManager
        taskManager.cancelCompletion = {
            self.downloadTasks.removeValue(forKey: url)
        }
        return taskManager
    }
    
    /** 暂停下载*/
    func cancel(_ url: String) -> Void {
        let task = downloadTasks[url]
        task?.downloadRequest?.cancel()
        task?.cancelCompletion = {
            self.downloadTasks.removeValue(forKey: url)
        }
    }
    /** 删除单个下载*/
    func delete(_ url: String) -> Void {
        let task = downloadTasks[url]
        task?.downloadStatus = .suspend
        task?.downloadRequest?.cancel()
        delete(task: task, url: url)
        task?.cancelCompletion = {
            self.delete(task: task, url: url)
        }
    }
    
    private func delete(task: DownloadTaskManager?, url: String) -> Void {
        if let path = downloadPlist[url] as? String {
            let filePath = fileManger.cache.appendingPathComponent("\(downloadFolder)/\(path)")
            do {
                try fileManger.removeItem(at: filePath)
               
            } catch let err {
              
            }
        }
        
        downloadTasks.removeValue(forKey: url)
        dataPlist.removeObject(forKey: url)
        downloadPlist.removeObject(forKey: url)
        progressPlist.removeObject(forKey: url)
        dataPlist.write(to: dataPath, atomically: true)
        progressPlist.write(to: progressPath, atomically: true)
        downloadPlist.write(to: downloadPath, atomically: true)
        
    }
    
    /** 下载完成路径*/
    func downloadFilePath(_ url: String) -> URL? {
        if let path = downloadPlist[url] as? String {
            return fileManger.cache.appendingPathComponent("\(downloadFolder)/\(path)")
        }
        return nil
    }
    /** 全部下载的文件*/
    func allDownloadFilePath() -> NSMutableDictionary {
        return fileManger.dictionaryOfData("downloadPath.plist")
    }
    /** 下载百分比*/
    func downloadPercent(_ url: String) -> Double {
        let percent = progressPlist[url] as? Double
        if percent == 1 && downloadPlist[url] == nil {
            return 0
        }
        return percent ?? 0
    }
    
    /** 下载状态*/
    func downloadStatus(_ url: String) -> DownloadStatus {
        let task = downloadTasks[url]
        if downloadPercent(url) == 1 { return .complete }
        return task?.downloadStatus ?? .suspend
    }
    
    /** 下载进度*/
    @discardableResult
    func downloadProgress(_ url: String, progress: @escaping (Double) -> ()) -> DownloadTaskManager? {
        if let task = downloadTasks[url], downloadPercent(url) < 1 {
            task.downloadProgress(progress: { pro in
                progress(pro)
            })
            return task
        } else {
            let pro = downloadPercent(url)
            progress(pro)
            return nil
        }
    }
}

public enum DownloadStatus: Int { /** 下载状态*/
    case normal
    case downloading
    case suspend
    case complete
    case fail
}

class DownloadTaskManager {
    fileprivate var downloadRequest: DownloadRequest?
    fileprivate var downloadStatus: DownloadStatus = .suspend
    fileprivate var cancelCompletion: (()->())?
    
    var url: String?
    @discardableResult
    fileprivate func download(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil) -> DownloadTaskManager {
            self.url = url
            let destination = downloadDestination()
            let resumeData = dataPlist[url] as? Data
            if let resume = resumeData {
                downloadRequest = Alamofire.download(resumingWith: resume, to: destination)
            } else {
                downloadRequest = Alamofire.download(url, method: method, parameters: parameters, encoding: encoding, headers: headers, to: destination)
            }
        downloadStatus = .downloading
        return self
    }
    
    /** 下载进度*/
    @discardableResult
    open func downloadProgress(progress: @escaping ((Double) -> Void)) -> DownloadTaskManager {
        downloadRequest?.downloadProgress(closure: { pro in
            progressPlist[self.url!] = pro.fractionCompleted
            progressPlist.write(to: progressPath, atomically: true)
            progress(pro.fractionCompleted)
        })
        return self
    }
    
    func response(completion: @escaping (Alamofire.Result<String>)->()) -> Void {
        downloadRequest?.responseData(completionHandler: { (resData) in
            switch resData.result {
            case .success:
                self.downloadStatus = .complete
                let str = resData.destinationURL?.absoluteString
                if self.cancelCompletion != nil { self.cancelCompletion!() }
                completion(Alamofire.Result.success(str!))
                
            case .failure(let error):
                self.downloadStatus = .suspend
                dataPlist[self.url!] = resData.resumeData
                dataPlist.write(to: dataPath, atomically: true)
                if self.cancelCompletion != nil { self.cancelCompletion!() }
                completion(Alamofire.Result.failure(error))
            }
        })
        
    }
    
    /** 下载位置*/
    private func downloadDestination() -> DownloadRequest.DownloadFileDestination {
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            let fileURL = fileManger.cache.appendingPathComponent("\(downloadFolder)/\(response.suggestedFilename!)")
            downloadPlist[self.url!] = response.suggestedFilename!
            downloadPlist.write(to: downloadPath, atomically: true)
            plog(fileURL.path)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        return destination
    }
    
}



// MARK: - filePath
fileprivate let dataPlist = fileManger.dictionaryOfData("DaisyData.plist")
fileprivate let progressPlist = fileManger.dictionaryOfData("DaisyProgress.plist")
fileprivate let downloadPlist = fileManger.dictionaryOfData("downloadPath.plist")

fileprivate let progressPath = fileManger.cache.appendingPathComponent("DaisyProgress.plist")
fileprivate let dataPath = fileManger.cache.appendingPathComponent("DaisyData.plist")
fileprivate let downloadPath = fileManger.cache.appendingPathComponent("downloadPath.plist")
