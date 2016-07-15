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
    static func new(name: String, location: String, startTime: Moment, endTime: Moment, teamId: String,  punishmentType: String, punishmentComment: String, extraName: String, extra: AnyObject, completionHandler: (Meeting?, MyError?) -> Void) {
        var parameters: [String: AnyObject] = [
            "name": name,
            "location": location,
            "startTime": startTime.toString(),
            "endTime": endTime.toString(),
            "team": teamId,
            "punishmentType": punishmentType,
            "punishmentComment": punishmentComment
        ]
        parameters[extraName] = extra
        
        log.info("\(parameters)")
        Alamofire.request(.POST, "\(baseUrl)\(meetingModule)new", parameters: parameters).responseMyObject(completionHandler)
    }
    
    static func getMemberLates(meetingId: String, completionHandler: ([Late]?, MyError?) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)\(meetingModule)\(meetingId)/members").responseMyArray(completionHandler)
    }
    
    static func getMeetings(completionHandler: ([Meeting]?, MyError?) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)\(meetingModule)me").responseMyArray(completionHandler)
    }
    
    static func setLates(meetingId: String, lates: [Late], completionHandler: (SimpleResponseResult?, MyError?) -> Void){
        let dispatchGroup = dispatch_group_create()
        var isSuccess = true
        for late in lates {
            dispatch_group_enter(dispatchGroup)
            Alamofire.request(.POST, "\(baseUrl)late/new", parameters: [
                "userId"    : late.user.id,
                "meetingId" : meetingId,
                "duration"  : late.lateDetail.duration
                ]).validate().responseJSON {
                response in
                switch response.result {
                case .Success:
                    break
                case .Failure:
                    isSuccess = false
                }
                dispatch_group_leave(dispatchGroup)
            }
        }
        
        dispatch_group_async(dispatchGroup, dispatch_get_main_queue()) {
            if (isSuccess) {
                completionHandler(SimpleResponseResult.Success, nil)
            } else {
                completionHandler(SimpleResponseResult.Failure("xxx"), MyError.Unknown("xxx"))
            }
        }
    }
    
    static func addMeetingMembers(meetingId: String, memberIds: [String], completionHandler: (SimpleResponseResult?, MyError?) -> Void) {
        Alamofire.request(.POST, "\(baseUrl)\(meetingModule)addMeetingMembers", parameters: [
                "meetingId": meetingId,
                "memberIds": memberIds
            ]).responseMyObject(completionHandler)
    }
}