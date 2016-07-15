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
     
        self.storeHouseRefreshControl = CBStoreHouseRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: #selector(TeamMainTableViewController.doRefresh), plist: "storehouse", color: UIColor.blackColor(), lineWidth: 2.0, dropHeight: 60, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: false, internalAnimationFactor: 0.5)
//        self.tableView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(TeamMainTableViewController.handleSwipeGesture(_:))))

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView(frame: .zero)
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
    
    @objc func handleSwipeGesture(gr: UISwipeGestureRecognizer) {
        guard gr.direction == .Left || gr.direction == .Right else {
            return
        }
        if let indexPath = self.tableView.indexPathForRowAtPoint(gr.locationInView(self.tableView)) {
            self.punishments.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: gr.direction == .Right ? .Right : .Left)
        }
    }
    
    // MARK: - Table view data source
    
    func doRefresh() {
        self.getInitialLates()
        self.getPunishmentSum()
    }
    
    func getPunishmentSum() {
        User.loginUser?.teams.last?.getPunishmentSum {
            punishmentSum, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let punishmentSum = punishmentSum {
                self.punishmentSum = punishmentSum
                self.tableView.reloadData()
            }
            if self.isFirstLoading {
                self.isFirstLoading = false
            }
        }
    }
    
    func getInitialLates() {
//        LoadingAnimation.show()
        
        self.isLoading = true
        User.loginUser?.teams.last?.getLates() {
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
            
            cell.moneyCntLabel <- "💰💰💰 \(self.punishmentSum) 大洋"
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
//                button.backgroundColor = UIColor.flatWatermelonColor()
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                
                button.sizeToFit()
                button.frame.size = CGSize(width: button.frame.size.width + 20, height: button.frame.size.height)
                button.closure = {
                    let alert = UIAlertController(title: "下午茶好喝吗？", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "好喝", style: UIAlertActionStyle.Default) {
                        alertAction in
                            User.loginUser?.teams.last?.implementPunishment(punishment.id) {
                                _, error in
                                if let error = error {
                                    ErrorHandlerCenter.handleError(error, sender: self)
                                } else {
                                    self.getInitialLates()
                                }
                            }
                    })
                    
                    alert.addAction(UIAlertAction(title: "不好喝", style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
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
        if let consumeController = (segue.destinationViewController as? UINavigationController)?.topViewController as? ConsumeTableViewController {
            consumeController.maxAmount = self.punishmentSum
            consumeController.dismissCallBack = {
                name, amount in
                self.getPunishmentSum()
                if let team = User.loginUser?.teams.last {
                    team.consume(name, amount: amount) {
                        _, error in
                        if let error = error {
                            ErrorHandlerCenter.handleError(error, sender: self)
                        }
                    }
                }
            }
        } else if let consumeRecordTableViewController = segue.destinationViewController as? ConsumeRecordTableViewController {
            if let team = User.loginUser?.teams.last {
                consumeRecordTableViewController.team = team
            } else {
                LoadingAnimation.showAndDismiss("孩纸 你没有队伍", delay: 1)
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
