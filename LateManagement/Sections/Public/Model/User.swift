//
//  User.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: JSONInitialable {
    var id: String
    var email: String
    var name: String
    var team: Team?
    var avatarURL: NSURL = NSURL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1468239079576&di=ff19d9145da36bf7d5874b57c221ffb7&imgtype=jpg&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Feac4b74543a9822657a37b178882b9014a90eba4.jpg")!
    
    private static var _loginUser: User?
    static var loginUser: User? {
        get {
            return User()
        }
        
        set {
            User._loginUser = newValue
        }
    }
    
    convenience init() {
        self.init(id: "id", email: "email", name: "name", team: Team())
    }
    
    init(id: String, email: String, name: String, team: Team?) {
        self.id = id
        self.email = email
        self.name = name
        self.team = team
    }
    
    required init?(json: JSON) {
        self.id = json["id"].stringProperty
        self.email = json["email"].stringProperty
        self.name = json["name"].stringProperty
        self.team = Team(json: json["team"])
    }
    
    func getPunishments(completionHandler: ([Punishment]?, MyError?) -> Void) {
        var punishments = [Punishment]()
        for _ in 0 ... 10 {
            punishments.append(Punishment())
        }
        
        completionHandler(punishments, nil)
    }
    
    static func getAllUser(start: Int = 0, end: Int = -1, completionHandler: ([User]?, MyError?) -> Void) {
        var users = [User]()
        for i in 0 ..< 10 {
            users.append(User(id: "id\(i)", email: "email\(i)", name: "name\(i)", team: Team()))
        }
        
        completionHandler(users, nil)
    }
    
    static func searchUserByString(string: String, completionHandler: ([User]?, MyError?) -> Void) {
        var users = [User]()
        for i in 0 ..< 10 {
            users.append(User(id: "id\(i)", email: "email\(i)", name: "name\(i)", team: Team()))
        }
        
        completionHandler(users, nil)
    }
}