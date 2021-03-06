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
    var id: String
    var user: User
    var total: Int
    var meeting: Meeting
    var isImplemented: Bool
    var duation: Int
    
    init() {
        self.id = "id"
        self.user = User()
        self.total = 2333
        self.duation = 10
        self.meeting = Meeting()
        self.isImplemented = true
    }
    
    required init?(json: JSON) {
        self.id = json["id"].stringValue
        self.user = User(json: json["user"]) ?? User()
        self.duation = json["duration"].intValue
        self.total = json["total"].intValue
        self.meeting = Meeting(json: json["meeting"]) ?? Meeting()
        self.isImplemented = json["state"].string != "created"
    }
}