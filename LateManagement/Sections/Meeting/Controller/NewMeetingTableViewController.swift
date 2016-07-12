//
//  NewMeetingTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import Eureka
import SwiftMoment

class NewMeetingTableViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultStartDate = (moment() + 1.days)
        self.form +++ Section()
            <<< TextRow("name") {
                row in
                row.title = "会议名称"
            }
            <<< TextRow("location") {
                row in
                row.title = "会议地点"
            }
            <<< DateInlineRow("date") {
                row in
                row.title = "日期"
                row.value = defaultStartDate.date
                row.minimumDate = NSDate()
                }
            <<< TimeRow("startTime") {
                row in
                row.title = "开始时间"
                row.value = (defaultStartDate).date
                }.onChange {
                    [unowned self]
                    row in
                    if let endTimeRow = self.form.rowByTag("endTime") as? TimeRow {
                        let startTime = row.value
                        
                        print("onChange")
                        if let endTime = endTimeRow.value where startTime?.compare(endTime) != .OrderedAscending {
                            endTimeRow.value = row.value?.dateByAddingTimeInterval(1.hours.seconds)
                            endTimeRow.updateCell()
                        }
                    }
                }
            <<< TimeRow("endTime") {
                row in
                row.title = "结束时间"
                row.value = (defaultStartDate).date.dateByAddingTimeInterval(1.hours.seconds)
            }
        
    }
}
