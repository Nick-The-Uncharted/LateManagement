//
//  MeetingDetailTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import SwiftMoment

class MeetingDetailTableViewController: UITableViewController {
    var meeting: Meeting?
    var lates = [Late]()
    
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return true
        }
        
        set {}
    }
    
    // MARK: Actions
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        guard let meeting = self.meeting else {return}
        meeting.setLates(lates.filter{$0.duration > 0}) {
            _, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerReusableCell(MeetingTableViewCell.self)
        self.tableView.registerReusableCell(TableViewCell1.self)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(MeetingDetailTableViewController.handleLongPressGesture(_:))))
        
        self.getInitLates()
    }

    
    @objc func handleLongPressGesture(gr: UILongPressGestureRecognizer) {
        guard let meeting = self.meeting else {return}
        if let indexPath = tableView.indexPathForRowAtPoint(gr.locationInView(self.tableView)) {
            let alert = UIAlertController(title: "迟到时间", message: "(分钟)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default) {
                    alertAction in
                if let late = self.getLateAtIndexPath(indexPath), duration = alert.textFields?.first?.text {
                    if let duration = Int(duration) {
                        late.duration = duration
                    }
                }
                })
            alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.text = "\(Int((moment() - meeting.startTime).minutes))"
            })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    func getInitLates() {
        guard let meeting = self.meeting else {return}
        meeting.getMembers {
            users, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let users = users {
                self.lates = users.map {Late(user: $0, duration: 0)}
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.lates.count
        }
    }
    
    func getLateAtIndexPath(indexPath: NSIndexPath) -> Late? {
        guard indexPath.row < self.lates.count else {return nil}
        return self.lates[indexPath.row]
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let meeting = self.meeting else {return UITableViewCell()}
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MeetingTableViewCell
            cell.udpateWithMeeting(meeting)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as TableViewCell1
            
            if let late = self.getLateAtIndexPath(indexPath) {
                cell.updateWithPresenter(late.user)
                if late.duration > 0 {
                    let label = UILabel()
                    label.text = "\(late.duration)"
                    label.sizeToFit()
                    cell.accessoryView = label
                } else {
                    cell.accessoryType = .None
                }
            }
            
            return cell
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let meeting = meeting else {return}
        if lates[indexPath.row].duration > 0 {
           lates[indexPath.row].duration = Int((moment() - meeting.startTime).minutes)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
