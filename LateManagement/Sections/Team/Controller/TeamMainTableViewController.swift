//
//  TeamMainTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class TeamMainTableViewController: UITableViewController {
    var punishments = [Punishment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerReusableCell(TableViewCell1.self)
        self.tableView.registerReusableCell(MoneyPoolTableViewCell.self)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        self.getInitialLates()
    }
    
    // MARK: - Actions
    func consumeButtonTouched(button: UIButton) {
        self.performSegueWithIdentifier("showConsume", sender: nil)
    }
    
    // MARK: - Table view data source
    
    func getInitialLates(completionHandler: SimpleBlock? = nil) {
        User.loginUser?.team?.getLates() {
            punishments, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let punishments = punishments {
                self.punishments = punishments
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
            return self.punishments.count
        }
    }
    
    func punishmentForIndexPath(indexPath: NSIndexPath) -> Punishment? {
        guard indexPath.row < self.punishments.count else {return nil}
        return self.punishments[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell() as MoneyPoolTableViewCell
            
            cell.moneyCntLabel <- 123
            cell.consumeButtonTouchedCallback = {
                // 跳转到消费
                self.performSegueWithIdentifier("showConsume", sender: nil)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell() as TableViewCell1
            
            
            if let punishment = self.punishmentForIndexPath(indexPath) {
                cell.updateWithPresenter(punishment)
                let button = ClosureButton(type: .Custom)
                button.setTitle("实施惩罚", forState: .Normal)
                button.setTitleColor(.blackColor(), forState: .Normal)
                button.sizeToFit()
                button.closure = {
                    print(punishment.content)
                }
                cell.accessoryView = button
            }
            
            return cell
        }
    }
    

    @IBAction func unwindToTeamController(sender: UIStoryboardSegue) {
        if let consumeController = sender.sourceViewController as? ConsumeTableViewController {
            print(consumeController.nameTextInput.text)
        }
    }
}
