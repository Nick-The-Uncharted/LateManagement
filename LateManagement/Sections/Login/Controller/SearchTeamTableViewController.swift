//
//  SearchTeamTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class SearchTeamTableViewController: SearchTableViewController {
    // MARK: Actions
    
    @IBAction func cancelButtonTouched(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func getInitailData(completionHandler: SimpleBlock? = nil) {
        Team.getAllTeams {
            teams, error in
            self.handleInititalData(teams?.map{$0 as SearchPresentable}, error: error, completionHandler: completionHandler)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showTeamInfo", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let teamInfoVC = segue.destinationViewController as? TeamInfoTableViewController {
            if let selectedIndex = self.tableView.indexPathForSelectedRow {
                teamInfoVC.team = self.presenters[selectedIndex.row] as? Team
            }
        }
    }
}