//
//  MeetingAPI.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import Alamofire
import SwiftMoment

class MeetingAPI {
    static func new(name: String, location: String, startTime: Moment, endTime: Moment, teamId: String, completionHandler: (Meeting?, MyError?) -> Void) {
        Alamofire.request(.POST, "\(baseUrl)\(meetingModule)", parameters: [
                "name": name,
            "location": location,
           "startTime": startTime.toString(),
             "endTime": endTime.toString(),
                "team": teamId
            ]).responseMyObject(completionHandler)
    }
    
    static func getMembers(meetingId: String, completionHandler: ([User]?, MyError?) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)\(meetingModule)").responseMyArray(completionHandler)
    }
    
    static func getMeetings(completionHandler: ([Meeting]?, MyError?) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)\(meetingModule)me").responseMyArray(completionHandler)
    }
    
    static func setLates(meetingId: String, lates: [Late], completionHandler: (SimpleResponseResult?, MyError?) -> Void){
        
    }
    
    static func addMeetingMembers(meetingId: String, memberIds: [String], completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        Alamofire.request(.POST, "\(baseUrl)\(meetingModule)addMeetingMembers").responseMyObject(completionHandler)
    }
}