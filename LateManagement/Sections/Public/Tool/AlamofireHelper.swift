//
//  AlamofireHelper.swift
//  MiBox2.0
//
//  Created by administrasion on 3/16/16.
//  Copyright © 2016 MiBox. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AlamofireHelper {
    static private func getObjectSerializer<T: JSONInitialable>(_: T.Type) -> ResponseSerializer<T, MyError> {
        return ResponseSerializer<T, MyError> { request, response, data, error in
            if error != nil {
                log.error("\(error)")
                return .Failure(.ServerError(""))
            } else if let data = data {
                let json = JSON(data: data)
                log.debug("\(JSON(data: data))")
                if !json["errorMessage"].notExists() || json["result"].int == 0 {
                    return .Failure(.ServerError(""))
                }
                let resultJson = json["result"].isExists() ? json["result"] : json
                
                if let element = T(json: resultJson) {
                    return .Success(element)	
                } else {
                    return .Failure(.ServerError(""))
                }
            }
            return .Failure(.ServerError(""))
        }
        
    }

    
    static private func getArraySerializer<T: JSONInitialable>(_: T.Type) -> ResponseSerializer<[T], MyError> {
        return ResponseSerializer<[T], MyError> { request, response, data, error in
            if error != nil {
                return .Failure(.ServerError("\(response?.statusCode ?? -1)"))
            } else if let data = data {
                let json = JSON(data: data)
                log.debug("\(JSON(data: data))")
                if !json["errorMessage"].notExists() || json["result"].int == 0 {
                    return .Failure(.ServerError(""))
                }
                
                var array = [T]()
                
                var resultJSON = json["result"]
                if resultJSON == nil {
                    resultJSON = json
                }
                
                for (_, elementJson) in resultJSON {
                    if let element = T(json: elementJson) {
                        array.append(element)
                    }
                }
                
                return .Success(array)
            }
            return .Failure(.ServerError(""))
        }
        
    }
}

extension Alamofire.Request {    
    func responseMyArray<T: JSONInitialable>(completionHandler: ([T]? , MyError?) -> Void) -> Self {
        let myCompletionHandler: (Response<[T], MyError>) -> Void = {
            response in
            switch response.result {
            case let .Success(array):
                completionHandler(array, nil)
            case let .Failure(error):
                completionHandler(nil, error)
            }
        }
        
        return validate().response(responseSerializer: AlamofireHelper.getArraySerializer(T.self),
            completionHandler: myCompletionHandler)
    }
    
        
          
    func responseMyObject<T: JSONInitialable>(completionHandler: (T? , MyError?) -> Void) -> Self {
        let myCompletionHandler: (Response<T, MyError>) -> Void = {
            response in
            switch response.result {
            case let .Success(obj):
                completionHandler(obj, nil)
            case let .Failure(error):
                completionHandler(nil, error)
            }
        }
        
        return validate().response(responseSerializer: AlamofireHelper.getObjectSerializer(T.self),
            completionHandler: myCompletionHandler)
    }
}