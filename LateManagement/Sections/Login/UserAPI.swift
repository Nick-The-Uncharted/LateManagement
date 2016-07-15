//
//  UserAPI.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import Alamofire

class UserAPI {
    static func login(email: String, password: String, completionHandler: (User?, MyError?) -> Void) {
        Alamofire.request(.POST, "\(baseUrl)\(userModule)login", parameters: ["email": email, "password": password]).responseMyObject(completionHandler)
    }
    
    static func getAllUser(completionHandler: ([User]?, MyError?) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)\(userModule)").responseMyArray(completionHandler)
    }
    
    static func getPunishments(completionHandler: ([Punishment]?, MyError?) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)late/myRecords").responseMyArray(completionHandler)
    }
}