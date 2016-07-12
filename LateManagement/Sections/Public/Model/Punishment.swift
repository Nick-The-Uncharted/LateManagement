//
//  Late.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftyJSON

class Punishment: JSONInitialable {
    var user: User
    var count: Int
    var meeting: Meeting
    var isImplemented: Bool
    
    init() {
        self.user = User()
        self.count = 2333
        self.meeting = Meeting()
        self.isImplemented = true
    }
    
    required init?(json: JSON) {
        self.user = User(json: json["user"]) ?? User()
        self.count = json["count"].intValue
        self.meeting = Meeting(json: json["meeting"]) ?? Meeting()
        self.isImplemented = json["isImplemented"].boolValue
    }
}