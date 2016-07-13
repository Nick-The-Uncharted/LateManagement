//
//  NewTeamInfoTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import UIKit

class NewTeamInfoTableViewController: UITableViewController {
    // MARK: Outlets
    @IBOutlet weak var teamNameTextField: UITextField!
    
    
    // MARK: Actions
    
    @IBAction func cancelButtonTouched(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        teamNameTextField.placeholder = "队名"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let searchUserVC = segue.destinationViewController as? SearchUserTableViewController {
            searchUserVC.dismissCallback = {
                [unowned self]
                users in
                if let user = User.loginUser {
                    LoadingAnimation.show("创建中……")
                    var memeberIds = users.map{$0.id}
                    memeberIds.append(user.id)
                    TeamAPI.new(self.teamNameTextField.text!, managerId: user.id, memberIds: memeberIds) {
                        team, error in
                        if let error = error {
                            ErrorHandlerCenter.handleError(error, sender: self)
                        } else if let team = team {
                            log.info("create team \(team.name) success")
                        }
                        LoadingAnimation.dismiss()
                    }
                }
            }
        }
    }
}