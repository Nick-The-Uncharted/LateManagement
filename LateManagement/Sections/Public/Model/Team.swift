//
//  Team.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftyJSON

class Team: JSONInitialable {
    var id: String
    var name: String
    var avatarURL: NSURL = NSURL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1468239079576&di=ff19d9145da36bf7d5874b57c221ffb7&imgtype=jpg&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Feac4b74543a9822657a37b178882b9014a90eba4.jpg")!
    var manager: User
    var members: [User]
    
    init() {
        self.id = ""
        self.name = ""
        self.manager = User()
        self.members = []
    }
    
    required init?(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.manager = User(json: json["manager"]) ?? User()
        self.members = json["members"].flatMap{User(json: $1)}
    }
    
    static func new(name: String, managerId: String, memberIds: [String], completionHandler: (Team?, MyError) -> Void) {
        TeamAPI.new(name, managerId: managerId, memberIds: memberIds) {
            team, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error)
            } else if let team = team {
                log.info("create team \(team.name) success")
                User.loginUser?.teams.append(team)
            }
        }
    }
    
    static func getAllTeams(start: Int = 0, end: Int = -1, completionHandler: ([Team]?, MyError?) -> Void) {
        TeamAPI.getAllTeams(completionHandler)
    }
    
    func getLates(start: Int = 0, end: Int = -1, completionHandler: (([Punishment]?, MyError?) -> Void)) {
        TeamAPI.getLates(self.id, completionHandler: completionHandler)
    }
    
    func getPunishmentSum(completionHandler: (Int?, MyError?) -> Void) {
        TeamAPI.getTeamPunishmentSum(self.id, completionHandler: completionHandler)
    }
    
    func consume(name: String, amount: Int, completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        TeamAPI.consume(self.id, name: name, amount: amount, completionHandler: completionHandler)
    }
    
    func getConsumeRecords(completionHandler: ([ConsumeRecord]?, MyError?) -> Void) {
        TeamAPI.getConsumeRecords(self.id, completionHandler: completionHandler)
    }
    
    func enroll(completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        TeamAPI.enroll(self.id, completionHandler: completionHandler)
    }
    
    func implementPunishment(lateId: String, completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        TeamAPI.implementPunishment(lateId, completionHandler: completionHandler)
    }
    
    func getTopPunishemnt(completionHandler: (TopPunishment?, MyError?) -> Void) {
        TeamAPI.getTopPunishemnt(self.id, completionHandler: completionHandler)
    }
}