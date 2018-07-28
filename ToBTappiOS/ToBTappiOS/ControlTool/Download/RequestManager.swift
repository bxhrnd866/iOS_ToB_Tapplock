//
//  RequestManager.swift
//  SwiftLib
//
//  Created by nb616 on 2017/10/19.
//  Copyright © 2017年 nb616. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RequestManager {
    static let `default` = RequestManager()
    fileprivate var dataRequest: DataRequest?
    fileprivate var completionClosure: (() -> ())?
 
    func request(_ url: String,
                 method: HTTPMethod = .get,
                 params: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil) -> RequestManager {
        dataRequest = Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
        return self
    }
    
    /** Json数据*/
    func jsonResponse(completion: @escaping (Alamofire.Result<Any>)->()) -> Void {
        let jsonRes = JsonResponse(dataRequest: dataRequest!, completionClosure: completionClosure)
        jsonRes.responseJson(completion: completion)
    }
    
     /** Data数据*/
    func dataResponse(completion: @escaping (Alamofire.Result<Data>)->()) -> Void {
        let dataRes = NetDataResponse(dataRequest: dataRequest!, completionClosure: completionClosure)
        dataRes.responseData(completion: completion)
    }
    
     /** String数据*/
    func stringResponse(completion: @escaping (Alamofire.Result<String>)->()) -> Void {
        let strRes = StringResponse(dataRequest: dataRequest!, completionClosure: completionClosure)
        strRes.responseString(completion: completion)
    }
}


class RequestResponse {
    
    fileprivate var dataRequest: DataRequest
    fileprivate var completionClosure: (()->())?
    fileprivate init(dataRequest: DataRequest, completionClosure: (()->())?) {
        self.dataRequest = dataRequest
        self.completionClosure = completionClosure
    }
    
}

class JsonResponse: RequestResponse {
    func responseJson(completion: @escaping (Alamofire.Result<Any>)->()) -> Void {
        dataRequest.responseJSON { response in
            completion(response.result)
            
        }
        
    }
}

class StringResponse: RequestResponse {
    func responseString(completion: @escaping (Alamofire.Result<String>)->()) -> Void {
        dataRequest.responseString { response in
            completion(response.result)
            
        }
    }
}

class NetDataResponse: RequestResponse {
    func responseData(completion: @escaping (Alamofire.Result<Data>)->()) -> Void {
        dataRequest.responseData { response in
            completion(response.result)
        }
    }
}







