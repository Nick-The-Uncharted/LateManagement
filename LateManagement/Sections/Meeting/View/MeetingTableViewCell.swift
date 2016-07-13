//
//  MeetingTableViewCell.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class MeetingTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeAndPlaceLabel: UILabel!
    @IBOutlet weak var punishmentLabel: UILabel!
    
    func udpateWithMeeting(meeting: Meeting) {
        self.nameLabel <- meeting.name
        self.timeAndPlaceLabel <- "\(meeting.startTime.hour):\(meeting.startTime.minute) ~ \(meeting.endTime.hour):\(meeting.endTime.minute)"
        self.punishmentLabel <- meeting.punishmentRule.descrption
    }
}
