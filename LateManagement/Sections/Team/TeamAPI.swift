//
//  TeamAPI.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TeamAPI {
    static func new(name: String, managerId: String, memberIds: [String], completionHandler: ((Team?, MyError?) -> Void)) {
        Alamofire.request(.POST, "\(baseUrl)\(teamModule)", parameters:[
                "name": name,
                "manager": managerId,
                "members": memberIds
            ]).responseMyObject(completionHandler)
    }
    
    static func getLates(teamId: String, completionHandler: (([Punishment]?, MyError?) -> Void)) {
        Alamofire.request(.GET, "\(baseUrl)late/\(teamId)/created").responseMyArray(completionHandler)
    }
    
    static func addMembers(teamId: String, memberIds: [String], completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        Alamofire.request(.POST, "\(baseUrl)\(teamModule)addMembers", parameters: [
                "teamId": teamId,
                "memberIds": memberIds
            ]).responseMyObject(completionHandler)
    }
    
    static func getTeamPunishmentSum(teamId: String, completionHandler: (Int?, MyError?) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)\(teamModule)\(teamId)/bonus").responseJSON {
            response in
            switch response.result {
            case .Success:
                guard let data = response.data else {
                    completionHandler(nil, MyError.ServerError("no response data"))
                    return
                }
                let json = JSON(data: data)
                if let punishementSum = json["bonus"].int {
                    completionHandler(punishementSum, nil)
                } else {
                    completionHandler(nil, MyError.ServerError("wrong response data format"))
                }
            case let .Failure(error):
                completionHandler(nil, MyError.ServerError("error: \(error)"))
                return
            }
        }
    }
    
    static func consume(teamId: String, name: String, amount: Int, completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        Alamofire.request(.POST, "\(baseUrl)consume/spend", parameters: [
                "desc": name,
                "total": amount,
                "teamId": teamId
            ]).responseMyObject(completionHandler)
    }
    
    static func getConsumeRecords(teamId: String, completionHandler: ([ConsumeRecord]?, MyError?) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)consume/record", parameters: ["teamId": teamId]).responseMyArray(completionHandler)
    }
    
    static func getAllTeams(completionHandler: ([Team]?, MyError?) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)\(teamModule)").responseMyArray(completionHandler)
    }
    
    static func enroll(teamId: String, completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        Alamofire.request(.POST, "\(baseUrl)\(teamModule)enroll", parameters: ["teamId": teamId]).responseMyObject(completionHandler)
    }
    
    static func implementPunishment(lateId: String, completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        Alamofire.request(.POST, "\(baseUrl)late/\(lateId)/changeState").responseMyObject(completionHandler)
    }
    
    static func getTopPunishemnt(teamId: String, completionHandler: (TopPunishment?, MyError?) -> Void) {
        Alamofire.request(.POST, "\(baseUrl)late/latest", parameters: ["teamId": teamId]).responseMyObject(completionHandler)
    }
}