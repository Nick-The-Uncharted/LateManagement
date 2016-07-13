//
//  MineMainTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import CBStoreHouseRefreshControl

class MineMainTableViewController: UITableViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    var punishments = [Punishment]()
    var storeHouseRefreshControl: CBStoreHouseRefreshControl?
    var isLoading = false {
        didSet {
            self.tableView.reloadEmptyDataSet()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.setImageByURL(NSURL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1468323122808&di=4df1db5565c01157cc1ddf8a3683c99c&imgtype=jpg&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2015-01-07%2F231358320.jpg")!)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80

        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.registerReusableCell(MeetingTableViewCell.self)
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.storeHouseRefreshControl = CBStoreHouseRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: #selector(MineMainTableViewController.getInitPunishments), plist: "storehouse", color: UIColor.blackColor(), lineWidth: 2.0, dropHeight: 60, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: false, internalAnimationFactor: 0.5)
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getInitPunishments()
    }

    // MARK: - Table view data source
    func getInitPunishments() {
        self.isLoading = true
        User.loginUser?.getPunishments {
            punishments, error in
            self.isLoading = false
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let punishments = punishments {
                self.punishments = punishments
                self.tableView.reloadData()
            }
            self.storeHouseRefreshControl?.finishingLoading()
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
            cell.detailTextLabel! <- "出血￥\(punishment.total)"
            if punishment.isImplemented {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.storeHouseRefreshControl?.scrollViewDidScroll()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.storeHouseRefreshControl?.scrollViewDidEndDragging()
    }
}

extension MineMainTableViewController {
    override func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: self.isLoading ? "Loading……" : "竟然没迟到过, 不考虑让人生完整一下吗😃")
    }
    
    override func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
}
