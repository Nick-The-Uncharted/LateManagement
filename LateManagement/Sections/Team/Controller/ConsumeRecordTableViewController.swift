//
//  ConsumeRecordTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class ConsumeRecordTableViewController: UITableViewController {

    var team: Team?
    var consumeRecords = [ConsumeRecord]()
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return true
        }
        
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getInitRecords()
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        
        // 长得比较像 直接用了 罪过罪过。。。
        self.tableView.registerReusableCell(MeetingTableViewCell.self)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
    }
    

    // MARK: - Table view data source

    func getInitRecords() {
        self.team?.getConsumeRecords {
            consumeRecords, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let consumeRecords = consumeRecords {
                self.consumeRecords = consumeRecords
                self.tableView.reloadData()
            }
        }
    }
    
    func consumeRecordsAtIndexPath(indexPath: NSIndexPath) -> ConsumeRecord? {
        guard indexPath.row < self.consumeRecords.count else {return nil}
        return self.consumeRecords[indexPath.row]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.consumeRecords.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell() as MeetingTableViewCell
        if let consumeRecord = consumeRecordsAtIndexPath(indexPath) {
            cell.nameLabel <- consumeRecord.name
            cell.punishmentLabel <- "消费总额: \(consumeRecord.total)"
            cell.timeAndPlaceLabel <- consumeRecord.time.toString("yyyy-MM-dd HH:mm")
        }

        return cell
    }
}
