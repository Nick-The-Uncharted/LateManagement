//
//  PunishmentRule.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftyJSON

class PunishmentRule: JSONInitialable {
    var name: String
    var descrption: String
    
    required init?(json: JSON) {
        self.name = json["name"].stringProperty
        self.descrption = json["desc"].stringProperty
    }
    
    init() {
        self.name = "ruleName"
        self.descrption = "ruleDesc"
    }
}