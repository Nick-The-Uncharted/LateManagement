//
//  SearchUserTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import UIKit

class SearchUserTableViewController: SearchTableViewController {
    static var savedVC: UIViewController?
    
    var users = [User]()
    var filteredUsers = [User]()
    
    // MARK: Outlet
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        CustomTabBarController.becomeRootViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerReusableCell(TableViewCell1.self)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 62
        
        
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        
        self.getInitailUsers()
    }
    
    func getInitailUsers(completionHandler: SimpleBlock? = nil) {
        User.getAllUser {
            users, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let users = users {
                self.users = users
                self.tableView.reloadData()
            } else {
                ErrorHandlerCenter.handleError(.Unknown("Program Error"), sender: self)
            }
            
            completionHandler?()
        }
    }
    
    func getUserAtIndexPath(indexPath: NSIndexPath) -> User? {
        let user: User?
        if searchController.active {
            user = filteredUsers.get(indexPath.row)
        } else {
            user = users.get(indexPath.row)
        }
        
        return user
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredUsers.count
        } else {
            return users.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as TableViewCell1
        
        if let user = self.getUserAtIndexPath(indexPath) {
            cell.updateWithPresenter(user)
        } else {
            log.error("no user at index \(indexPath)")
        }
        
        
        cell.accessoryType = .Checkmark
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredUsers = self.users.filter {user in user.name.containsString(searchController.searchBar.text!)}
        self.tableView.reloadData()
    }
}