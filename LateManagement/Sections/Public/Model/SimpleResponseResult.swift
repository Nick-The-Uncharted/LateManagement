//
//  SimpleResponseResult.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SimpleResponseResult: JSONInitialable {
    case Success, Failure(String)
    init?(json: JSON) {
        if let msg = json["errorMsg"].string {
            self = .Failure(msg)
        } else {
            self = .Success
        }
    }
}