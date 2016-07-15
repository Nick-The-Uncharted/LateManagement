//
//  PunishmentRule.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PunishmentRule: JSONInitialable {
    case UserDefined(String)
    case Linear(Int)
    case Same(Int)
    
    var descrption: String {
        switch self {
        case let .UserDefined(userDesc):
            return userDesc
        case let .Linear(unitPrice):
            return "迟到罚\(unitPrice)元/分钟"
        case let .Same(price):
            return "一迟到就罚\(price)元"
        }
    }
    
    init?(json: JSON) {
        let type = json["type"]
        if type == "userdefined" {
            self = .UserDefined(json["desc"].stringValue)
        } else if type == "linear" {
            self = .Linear(json["unitPrice"].intValue)
        } else if type == "same" {
            self = .Same(json["price"].intValue)
        } else {
            return nil
        }
    }
    
    init() {
        self = .Linear(5)
    }
}