//
//  MineMainTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class MineMainTableViewController: UITableViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    var punishments = [Punishment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.setImageByURL(NSURL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1468323122808&di=4df1db5565c01157cc1ddf8a3683c99c&imgtype=jpg&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2015-01-07%2F231358320.jpg")!)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80

        self.tableView.registerReusableCell(MeetingTableViewCell.self)
        self.getInitPunishments()
    }

    // MARK: - Table view data source
    func getInitPunishments() {
        User.loginUser?.getPunishments {
            punishments, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let punishments = punishments {
                self.punishments = punishments
                self.tableView.reloadData()
            }
        }
    }

    func getPuninshmentAtIndexPath(indexPath: NSIndexPath) -> Punishment? {
        guard indexPath.row < self.punishments.count else {return nil}
        return self.punishments[indexPath.row]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.punishments.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "subtitle")
        if let punishment = self.getPuninshmentAtIndexPath(indexPath) {
            cell.textLabel! <- punishment.meeting.name
            cell.detailTextLabel! <- "出血￥\(punishment.count)"
            if punishment.isImplemented {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
}
