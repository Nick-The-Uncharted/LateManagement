//
//  ConsumeRecord.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftMoment
import SwiftyJSON

class ConsumeRecord: JSONInitialable {
    var time: Moment
    var total: Int
    var name: String
    
    required init?(json: JSON) {
        self.time = json["time"].time
        self.total = json["total"].intValue
        self.name = json["desc"].stringValue
    }
    
    init() {
        self.time = moment()
        self.total = 0
        self.name = "heihehi"
    }
}