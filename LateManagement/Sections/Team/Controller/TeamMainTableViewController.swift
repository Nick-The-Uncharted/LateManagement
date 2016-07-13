//
//  TeamMainTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import CBStoreHouseRefreshControl


class TeamMainTableViewController: UITableViewController {
    var punishments = [Punishment]()
    var punishmentSum = 0
    var isFirstLoading = true
    var storeHouseRefreshControl: CBStoreHouseRefreshControl?
    var isLoading = false {
        didSet {
            self.tableView.reloadEmptyDataSet()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerReusableCell(TableViewCell1.self)
        self.tableView.registerReusableCell(MoneyPoolTableViewCell.self)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
     
        self.storeHouseRefreshControl = CBStoreHouseRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: #selector(TeamMainTableViewController.getInitialLates), plist: "storehouse", color: UIColor.blackColor(), lineWidth: 2.0, dropHeight: 60, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: false, internalAnimationFactor: 0.5)

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getPunishmentSum()
        self.getInitialLates()
    }
    
    // MARK: - Actions
    func consumeButtonTouched(button: UIButton) {
        self.performSegueWithIdentifier("showConsume", sender: nil)
    }
    
    // MARK: - Table view data source
    
    func getPunishmentSum() {
        if isFirstLoading {
            LoadingAnimation.show()
        }
        User.loginUser?.teams.first?.getPunishmentSum {
            punishmentSum, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let punishmentSum = punishmentSum {
                self.punishmentSum = punishmentSum
                self.tableView.reloadData()
            }
            if self.isFirstLoading {
                self.isFirstLoading = false
                LoadingAnimation.dismiss()
            }
        }
    }
    
    func getInitialLates() {
//        LoadingAnimation.show()
        
        self.isLoading = true
        User.loginUser?.teams.first?.getLates() {
            punishments, error in
            self.storeHouseRefreshControl?.finishingLoading()
            self.isLoading = false
//            LoadingAnimation.dismiss()
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
            
            cell.moneyCntLabel <- "\(self.punishmentSum) 大洋"
            cell.selectionStyle = .None
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
                button.titleLabel?.font = UIFont.systemFontOfSize(14)
                button.setTitle("实施惩罚", forState: .Normal)
                button.setTitleColor(.blackColor(), forState: .Normal)
                button.sizeToFit()
                button.closure = {
                    print(punishment.content)
                }
                cell.selectionStyle = .None
                cell.accessoryView = button
            }
            
            return cell
        }
    }
    

    @IBAction func unwindToTeamController(sender: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let consumeController = sender?.sourceViewController as? ConsumeTableViewController {
            consumeController.dismissCallBack = {
                name, amount in
                if let team = User.loginUser?.teams.first {
                    team.consume(name, amount: amount) {
                        _, error in
                        if let error = error {
                            ErrorHandlerCenter.handleError(error, sender: self)
                        }
                    }
                }
            }
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.storeHouseRefreshControl?.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.storeHouseRefreshControl?.scrollViewDidEndDragging()
    }
}

extension TeamMainTableViewController {
    override func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: self.isLoading ? "Loading……" : "没有未结算迟到哦~")
    }
    
    override func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
}
