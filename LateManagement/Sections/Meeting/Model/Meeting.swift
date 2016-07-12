//
//  Meeting.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftMoment
import SwiftyJSON

class Meeting: JSONInitialable {
    var name: String
    var location: String
    var startTime: Moment
    var endTime: Moment
    var punishmentRule: PunishmentRule
    var team: Team

    required init?(json: JSON) {
        self.name = json["name"].stringProperty
        self.location = json["location"].stringProperty
        self.startTime = json["startTime"].time
        self.endTime = json["endTime"].time
        self.punishmentRule = PunishmentRule(json: json["punishment"]) ?? PunishmentRule()
        self.team = Team(json: json["team"]) ?? Team()
    }
    
    init() {
        self.name = "name"
        self.location = "1808"
        self.startTime = moment()
        self.endTime = moment()
        self.punishmentRule = PunishmentRule()
        self.team = Team()
    }
    
    static func getMeetings(completionHandler: ([Meeting]?, MyError?) -> Void) {
        var meetings = [Meeting]()
        for _ in 0 ... 10 {
            meetings.append(Meeting())
        }
        
        completionHandler(meetings, nil)
    }
}