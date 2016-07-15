//
//  MeetingDetailTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import SwiftMoment
import Material

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
        LoadingAnimation.show("更新迟到数据中……")
        meeting.setLates(lates.filter{$0.lateDetail.duration > 0}) {
            _, error in
            LoadingAnimation.dismiss()
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
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
    
    var addNewMemberButton: UIButton?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.addNewMemberButton = FabButton(frame: CGRect(origin: CGPoint(x: UIScreen.mainScreen().bounds.width - 70, y: UIScreen.mainScreen().bounds.height - 100), size: CGSize(width: 50, height: 50)))
        self.addNewMemberButton?.setTitle("+", forState: .Normal)
        self.addNewMemberButton?.addTarget(self, action: #selector(MeetingDetailTableViewController.addMemberButtonTouched), forControlEvents: .TouchUpInside)
        self.view.superview?.addSubview(addNewMemberButton!)
    }
    
    @objc func addMemberButtonTouched() {
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        guard let searchUserViewController = storyboard.instantiateViewControllerWithIdentifier("SearchUserTableViewController") as? SearchUserTableViewController else {return}
        searchUserViewController.dismissCallback = {
            [unowned self]
            users in
            self.navigationController?.popViewControllerAnimated(true)
            self.meeting?.addMembers(users.map{$0.id}) {
                _, error in
                if let error = error {
                    ErrorHandlerCenter.handleError(error, sender: self)
                } else {
                    self.doRefresh()
                }
            }
        }
        self.navigationController?.pushViewController(searchUserViewController, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addNewMemberButton?.removeFromSuperview()
    }

    
    @objc func handleLongPressGesture(gr: UILongPressGestureRecognizer) {
        guard let meeting = self.meeting else {return}
        let lateMinute = (moment() - meeting.startTime).minutes
        if lateMinute <= 0 {
            LoadingAnimation.showAndDismiss("会议还没开始呢", delay: 1)
            return
        }
        
        if let indexPath = tableView.indexPathForRowAtPoint(gr.locationInView(self.tableView)) {
            let alert = UIAlertController(title: "迟到时间", message: "(分钟)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) {
                    alertAction in
                if let late = self.getLateAtIndexPath(indexPath), duration = alert.textFields?.first?.text {
                    if let duration = Int(duration) {
                        guard duration >= 0 else {
                            LoadingAnimation.showAndDismiss("悟空你又调皮了", delay: 1)
                            return
                        }
                        late.lateDetail.duration = duration
                        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
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
        meeting.getMemberLates {
            lates, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let lates = lates {
                self.lates = lates
                self.tableView.reloadData()
            }
        }
    }
    
    func doRefresh() {
        guard let meeting = self.meeting else {return}
        LoadingAnimation.show("拉取中……")
        meeting.getMemberLates {
            lates, error in
            LoadingAnimation.dismiss()
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let lates = lates {
                self.lates = lates
                self.tableView.reloadData()
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
                if late.lateDetail.duration > 0 {
                    let label = UILabel()
                    label.text = "\(late.lateDetail.duration)分钟"
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
        if indexPath.section == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
        let lateMinute = Int((moment() - meeting.startTime).minutes)
        if lateMinute > 0 {
            lates[indexPath.row].lateDetail.duration = lateMinute
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        } else {
            LoadingAnimation.showAndDismiss("会议还没开始呢", delay: 1)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}