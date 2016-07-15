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
    override var hidesBottomBarWhenPushed: Bool {
        get {return true}
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var defaultStartDate = (moment() + 1.days)
        defaultStartDate = moment(["year": defaultStartDate.year,
            "month": defaultStartDate.month,
            "day": defaultStartDate.day,
            "hour": defaultStartDate.hour,
            "minute": defaultStartDate.minute]) ?? moment()
        
        var ignoreChange = false
        self.form +++ Section()
            <<< TextRow("name") {
                row in
                row.title = "会议名称"
            }
            <<< TextRow("location") {
                row in
                row.title = "会议地点"
            }
            <<< PickerInlineRow<String>("punishmentType") {
                row in
                row.title = "惩罚类型"
                row.value = "自定义"
                row.options = ["自定义", "线性增加", "一视同仁"]
            }
            <<< TextRow("customDescrption"){
                row in
                row.title = "自定义描述"
                row.hidden = Condition.Function(["punishmentType"]) {
                    form in
                    let row: PickerInlineRow<String>? = form.rowByTag("punishmentType")
                    if let value = row?.value {
                        return value != "自定义"
                    }
                    return true
                }
            }
            <<< IntRow("unitPrice") {
                row in
                row.title = "惩罚单价(每分钟)"
                row.hidden = Condition.Function(["punishmentType"]) {
                    form in
                    let row: PickerInlineRow<String>? = form.rowByTag("punishmentType")
                    if let value = row?.value {
                        return value != "线性增加"
                    }
                    return true
                }
            }
            <<< IntRow("price") {
                row in
                row.title = "罚款数"
                row.hidden = Condition.Function(["punishmentType"]) {
                    form in
                    let row: PickerInlineRow<String>? = form.rowByTag("punishmentType")
                    if let value = row?.value {
                        return value != "一视同仁"
                    }
                    return true
                }
            }
            <<< TextRow("punishmentComment") {
                row in
                row.title = "惩罚备注"
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
                    if ignoreChange {ignoreChange = false; return}
                    if let endTimeRow = self.form.rowByTag("endTime") as? TimeRow {
                        let startTime = row.value
                        
                        if let endTime = endTimeRow.value where startTime?.compare(endTime) != .OrderedAscending {
                            ignoreChange = true
                            endTimeRow.value = row.value?.dateByAddingTimeInterval(1.hours.seconds)
                            endTimeRow.updateCell()
                        }
                    }
                }
            <<< TimeRow("endTime") {
                row in
                row.title = "结束时间"
                row.value = (defaultStartDate).date.dateByAddingTimeInterval(1.hours.seconds)
                }.onChange {
                    [unowned self]
                    row in
                    if ignoreChange {ignoreChange = false; return}
                    if let startTimeRow = self.form.rowByTag("startTime") as? TimeRow {
                        guard let endTime = row.value else {return}
                        
                        if let startTime = startTimeRow.value where startTime.compare(endTime) != .OrderedAscending {
                            ignoreChange = true
                            startTimeRow.value = endTime.dateByAddingTimeInterval(-1.hours.seconds)
                            startTimeRow.updateCell()
                        }
                    }
                }
    }
    
    func validateForms() -> Bool {
        let values = self.form.values()
        if (values["name"] as? String)?.isEmpty != false {
            LoadingAnimation.showAndDismiss("会议名称不能为空")
            return false
        } else if (values["location"] as? String)?.isEmpty != false {
            LoadingAnimation.showAndDismiss("会议地点不能为空")
            return false
        }
        
        if let punishmentType = values["punishmentType"] as? String {
            switch punishmentType {
            case "自定义":
                if (values["customDescrption"] as? String)?.isEmpty != false {
                    LoadingAnimation.showAndDismiss("自定义惩罚描述不能为空")
                    return false
                }
            case "线性增加":
                let unitPrice = values["unitPrice"] as? Int
                if unitPrice == nil {
                    LoadingAnimation.showAndDismiss("惩罚单价不能为空")
                    return false
                } else if unitPrice <= 0 {
                    LoadingAnimation.showAndDismiss("惩罚单价必须为正数")
                    return false
                }
            case "一视同仁":
                let unitPrice = values["price"] as? Int
                if unitPrice == nil {
                    LoadingAnimation.showAndDismiss("总价不能为空")
                    return false
                } else if unitPrice <= 0 {
                    LoadingAnimation.showAndDismiss("总价必须为正数")
                    return false
                }
            default:
                break
            }
        }
        
        return true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return self.validateForms()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let loginUser = User.loginUser else {return}
        let values = form.values()
        guard
        let name = values["name"] as? String,
            location = values["location"] as? String,
            startTime = values["startTime"] as? NSDate,
            endTime = values["endTime"] as? NSDate,
            date = values["date"] as? NSDate,
            teamId = loginUser.teams.last?.id,
            punishmentType = values["punishmentType"] as? String
        else {return}
        let punishmentComment = (values["punishmentComment"] as? String) ?? ""
        
        var extraName = ""
        var extra: AnyObject = 1
        var punishmentTypeInEnglish = ""
        switch punishmentType {
        case "自定义":
            punishmentTypeInEnglish = "userdefined"
            extraName = "desc"
            extra = (values["customDescrption"] as? String) ?? ""
        case "线性增加":
            punishmentTypeInEnglish = "linear"
            extraName = "unitPrice"
            extra = (values["unitPrice"] as? Int) ?? ""
        case "一视同仁":
            punishmentTypeInEnglish = "same"
            extraName = "price"
            extra = (values["price"] as? Int) ?? ""
        default:
            break
        }
        
        var dateMoment = moment(date)
        dateMoment = dateMoment - (dateMoment.hour * dateMoment.hourInSeconds).seconds - (dateMoment.minute * dateMoment.minuteInSeconds).seconds - dateMoment.second.seconds
        var startTimeMoment = moment(startTime)
        var endTimeMoment = moment(endTime)
        
        startTimeMoment = dateMoment + (startTimeMoment.hour * startTimeMoment.hourInSeconds).seconds + (startTimeMoment.minute * startTimeMoment.minuteInSeconds).seconds + startTimeMoment.second.seconds
        endTimeMoment = dateMoment + (endTimeMoment.hour * endTimeMoment.hourInSeconds).seconds + (endTimeMoment.minute * endTimeMoment.minuteInSeconds).seconds + endTimeMoment.second.seconds
        
        guard !(name.isEmpty || location.isEmpty || teamId.isEmpty) else {return}
        if let searchUserVC = segue.destinationViewController as? SearchUserTableViewController {
            searchUserVC.dismissCallback = {
                users in
                CustomTabBarController.becomeRootViewController()
                Meeting.new(name, location: location, startTime: startTimeMoment, endTime: endTimeMoment, teamId: teamId, punishmentType: punishmentTypeInEnglish, punishmentComment: punishmentComment, extraName: extraName, extra: extra) {
                    meeting, error in
                    if let error = error {
                        ErrorHandlerCenter.handleError(error, sender: self)
                    } else if let meeting = meeting {
                        meeting.addMembers(users.map{$0.id}) {
                            _, error in
                            if let error = error {
                                ErrorHandlerCenter.handleError(error, sender: self)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension String: CustomStringConvertible {
    public var description: String {
        return self
    }
}
