//
//  TopPunishment.swift
//  LateManagement
//
//  Created by administrasion on 7/15/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftyJSON

class TopPunishment: JSONInitialable {
    var user: User
    var total: Int
    
    required init?(json: JSON) {
        self.user = User(json: json["user"]) ?? User()
        self.total = json["total"].intValue
    }
    
    init() {
        self.user = User()
        self.total = 0
    }
}