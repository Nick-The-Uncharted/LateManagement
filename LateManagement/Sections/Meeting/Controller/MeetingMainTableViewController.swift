//
//  MeetingMainTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import CBStoreHouseRefreshControl
import SwiftMoment
import DZNEmptyDataSet

class MeetingMainTableViewController: UITableViewController {
    var meetings = [Meeting]()
    var notFilteredMeetings = [Meeting]()
    var storeHouseRefreshControl: CBStoreHouseRefreshControl?
    var isLoading = false {
        didSet {
            self.tableView.reloadEmptyDataSet()
        }
    }
    @IBOutlet weak var dateSegment: UISegmentedControl!
    
    @IBAction func dateSegmentValueChanged(sender: UISegmentedControl) {
        self.updateMeetingBySegmentValue()
    }
    
    func isSameDay(lhs: Moment, rhs: Moment) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
    
    func updateMeetingBySegmentValue() {
        switch dateSegment.selectedSegmentIndex {
        case 0:
            meetings = notFilteredMeetings.filter{meeting in self.isSameDay(meeting.startTime, rhs: moment())}
        case 1:
            meetings = notFilteredMeetings.filter{meeting in self.isSameDay(meeting.startTime, rhs: moment() + 1.days)}
        case 2:
            meetings = notFilteredMeetings.filter{meeting in self.isSameDay(meeting.startTime, rhs: moment() + 2.days)}
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerReusableCell(MeetingTableViewCell.self)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        self.storeHouseRefreshControl = CBStoreHouseRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: #selector(MeetingMainTableViewController.getMeetings), plist: "storehouse", color: UIColor.blackColor(), lineWidth: 2.0, dropHeight: 60, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: false, internalAnimationFactor: 0.5)
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.navigationController?.pushViewController(MeetingDetailTableViewController(), animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getMeetings()
    }
    
    // MARK: - Table view data source
    
    @objc func getMeetings() {
        self.isLoading = true
        Meeting.getMeetings {
            meetings, error in
            self.isLoading = false
            self.storeHouseRefreshControl?.finishingLoading()
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let meetings = meetings {
                self.notFilteredMeetings = meetings
                self.updateMeetingBySegmentValue()
            }
        }
    }
    
    func meetingAtIndexPath(indexPath: NSIndexPath) -> Meeting? {
        guard indexPath.row < self.meetings.count else {return nil}
        return self.meetings[indexPath.row]
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MeetingTableViewCell
        if let meeting = meetingAtIndexPath(indexPath) {
            cell.udpateWithMeeting(meeting)
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let meeting = meetingAtIndexPath(indexPath) else {return}
        self.performSegueWithIdentifier("showMeetingDetail", sender: meeting)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let meetingDetailVC = segue.destinationViewController as? MeetingDetailTableViewController, meeting = sender as? Meeting {
            meetingDetailVC.meeting = meeting
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.storeHouseRefreshControl?.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.storeHouseRefreshControl?.scrollViewDidEndDragging()
    }
}

extension MeetingMainTableViewController {
    override func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: self.isLoading ? "Loading……" : "没有会议哦~")
    }
    
    override func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -100
    }
}
