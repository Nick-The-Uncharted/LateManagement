//
//  TeamInfoTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class TeamInfoTableViewController: UITableViewController {
    var team: Team?
    var members = [User]()
    @IBOutlet weak var teamIconImageView: UIImageView!
    
    // MARK: - Actions
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        // MARK: Outlet
        self.team?.enroll {
            _, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            }
        }
        CustomTabBarController.becomeRootViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerReusableCell(TableViewCell1.self)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
    
        if let team = team {
            self.teamIconImageView.setImageByURL(team.avatarURL)
        }
        self.getInitialMembers()
    }
    
    func getInitialMembers() {
        if let team = team {
            self.members = team.members
        } else {
            log.error("team is nil")
        }
    }
    
    func memberAtIndexPath(indexPath: NSIndexPath) -> User? {
        guard indexPath.row - 2 < self.members.count else {return nil}
        return self.members[indexPath.row - 2]
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count + 2
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let team = team {
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell(style: .Value1, reuseIdentifier: "rightDetail")
                cell.textLabel! <- "队名"
                cell.detailTextLabel! <- team.name
                return cell
            case 1:
                let cell = UITableViewCell(style: .Value1, reuseIdentifier: "rightDetail")
                cell.textLabel! <- "manager"
                cell.detailTextLabel! <- team.manager.name ?? "暂无"
                return cell
            default:
                let cell = self.tableView.dequeueReusableCell() as TableViewCell1
                if let member = self.memberAtIndexPath(indexPath) {
                    cell.updateWithPresenter(member)
                }
                return cell
            }
        } else {
            log.error("no team")
            return UITableViewCell()
        }
    }
}