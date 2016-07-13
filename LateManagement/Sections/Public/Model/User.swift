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
    var teams = [Team]()
    var avatarURL: NSURL = NSURL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1468239079576&di=ff19d9145da36bf7d5874b57c221ffb7&imgtype=jpg&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Feac4b74543a9822657a37b178882b9014a90eba4.jpg")!
    
    private static var _loginUser: User?
    static var loginUser: User? {
        get {
            return User._loginUser
        }
        
        set {
            User._loginUser = newValue
        }
    }
    
    convenience init() {
        self.init(id: "id", email: "email", name: "name", teams: [])
    }
    
    init(id: String, email: String, name: String, teams: [Team]) {
        self.id = id
        self.email = email
        self.name = name
        self.teams = teams
    }
    
    required init?(json: JSON) {
        self.id = json["id"].stringProperty
        self.email = json["email"].stringProperty
        self.name = json["name"].stringProperty
        self.teams = json["teams"].flatMap {Team(json: $0.1)}
    }
    
    func getPunishments(completionHandler: ([Punishment]?, MyError?) -> Void) {
        UserAPI.getPunishments(completionHandler)
    }
    
    static func getAllUser(start: Int = 0, end: Int = -1, completionHandler: ([User]?, MyError?) -> Void) {
        UserAPI.getAllUser(completionHandler)
    }
    
    static func searchUserByString(string: String, completionHandler: ([User]?, MyError?) -> Void) {
        var users = [User]()
        for i in 0 ..< 10 {
            users.append(User(id: "id\(i)", email: "email\(i)", name: "name\(i)", teams: []))
        }
        
        completionHandler(users, nil)
    }
    
    static func tryLogin(completionHandler: (User?, MyError?) -> Void) {
        guard let email = NSUserDefaults.standardUserDefaults().stringForKey("lastLoginEmail") else {
            completionHandler(nil, .NoEmail)
            return
        }
        
        if let password = KeychainHelper.getPassword(email) {
            User.login(email, password: password, completionHandler: completionHandler)
        }
    }
    
    static func login(email: String ,password: String, completionHandler: (User?, MyError?) -> Void) {
        UserAPI.login(email, password: password) {
            user, error in
            if let user = user {
                User.loginUser = user
                NSUserDefaults.standardUserDefaults().setObject(email, forKey: "lastLoginEmail")
                KeychainHelper.setPassword(email, password: password)
            }
            completionHandler(user, error)
        }
    }
}