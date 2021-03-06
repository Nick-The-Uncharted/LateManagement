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
    var dismissCallback: ([User] -> Void)?
    
    // MARK: Outlet
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        dismissCallback?(self.selelctedPresenters.flatMap{$0 as? User})
    }
 
    override func getInitailData(completionHandler: SimpleBlock? = nil) {
        User.getAllUser {
            users, error in
            self.handleInititalData(users?.map{$0 as SearchPresentable}, error: error, completionHandler: completionHandler)
        }
    }
}