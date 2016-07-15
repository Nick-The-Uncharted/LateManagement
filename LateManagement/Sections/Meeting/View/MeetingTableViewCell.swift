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
        self.nameLabel <- meeting.name + " (\(meeting.team.name)组)"
        self.timeAndPlaceLabel <- "\(meeting.startTime.hour.twoBit):\(meeting.startTime.minute.twoBit) - \(meeting.endTime.hour.twoBit):\(meeting.endTime.minute.twoBit)"
        self.punishmentLabel <- meeting.punishmentRule.descrption
    }
}
