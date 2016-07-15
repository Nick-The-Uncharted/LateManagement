//
//  Late.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftyJSON

class LateDetail: JSONInitialable {
    var duration: Int
    var id: String
    
    init() {
        self.id = "id"
        self.duration = -1
    }
    
    init(duration: Int) {
        self.id = "not Set"
        self.duration = duration
    }
    
    required init?(json: JSON) {
        self.id = json["id"].stringValue
        self.duration = json["duration"].intValue
    }
}

class Late: JSONInitialable {
    var user: User
    var lateDetail: LateDetail
    
    required init?(json: JSON) {
        self.user = User(json: json) ?? User()
        self.lateDetail = LateDetail(json: json["late"]) ?? LateDetail()
    }
    
    init(user: User, duration: Int = 0) {
        self.user = user
        self.lateDetail = LateDetail(duration: duration)
    }
}