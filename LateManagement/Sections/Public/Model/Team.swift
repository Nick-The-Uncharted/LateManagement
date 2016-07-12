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
        self.manager = User(id: "", email: "", name: "", team: nil)
        self.members = []
    }
    
    required init?(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.manager = User(json: json["manager"]) ?? User()
        self.members = json["members"].flatMap{User(json: $1)}
    }
    
    static func getAllTeams(start: Int = 0, end: Int = -1, completionHandler: ([Team]?, MyError?) -> Void) {
        var teams = [Team]()
        for i in 0 ... 10 {
            teams.append(Team(json: JSON(["id": "id\(i)", "name": "name\(i)"]))!)
            for _ in 0 ... 10 {
                teams[i].members.append(User(id: "id\(i)", email: "email\(i)", name: "name\(i)", team: Team()))
            }
        }
        completionHandler(teams, nil)
    }
    
    func getLates(start: Int = 0, end: Int = -1, completionHandler: (([Punishment]?, MyError?) -> Void)) {
        var lates = [Punishment]()
        for _ in 0 ... 10 {
            lates.append(Punishment())
        }
        completionHandler(lates, nil)
    }
}