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
    var id: String
    var name: String
    var location: String
    var startTime: Moment
    var endTime: Moment
    var punishmentRule: PunishmentRule
    var team: Team

    required init?(json: JSON) {
        if json.type != .Dictionary {return nil}
        self.id = json["id"].stringProperty
        self.name = json["name"].stringProperty
        self.location = json["location"].stringProperty
        self.startTime = json["startTime"].time
        self.endTime = json["endTime"].time
        self.punishmentRule = PunishmentRule(json: json["punishment"]) ?? PunishmentRule()
        self.team = Team(json: json["team"]) ?? Team()
    }
    
    init() {
        self.id = "id"
        self.name = "name"
        self.location = "1808"
        self.startTime = moment()
        self.endTime = moment()
        self.punishmentRule = PunishmentRule()
        self.team = Team()
    }
    
    func getMemberLates(completionHandler: ([Late]?, MyError?) -> Void) {
        MeetingAPI.getMemberLates(self.id, completionHandler: completionHandler)
    }
    
    func setLates(lates: [Late], completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        MeetingAPI.setLates(self.id, lates: lates, completionHandler: completionHandler)
    }
    
    static func getMeetings(completionHandler: ([Meeting]?, MyError?) -> Void) {
        MeetingAPI.getMeetings(completionHandler)
    }
    
    static func new(name: String, location: String, startTime: Moment, endTime: Moment, teamId: String, punishmentType: String, punishmentComment: String, extraName: String, extra: AnyObject, completionHandler: (Meeting?, MyError?) -> Void) {
        MeetingAPI.new(name, location: location, startTime: startTime, endTime: endTime, teamId: teamId, punishmentType: punishmentType, punishmentComment: punishmentComment, extraName: extraName, extra: extra, completionHandler: completionHandler)
    }
    
    func addMembers(memberIds: [String], completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        MeetingAPI.addMeetingMembers(self.id, memberIds: memberIds, completionHandler: completionHandler)
    }
}