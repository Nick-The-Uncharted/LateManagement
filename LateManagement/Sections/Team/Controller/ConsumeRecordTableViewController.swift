//
//  ConsumeRecordTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class ConsumeRecordTableViewController: UITableViewController {

    var consumeRecords = [ConsumeRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - Table view data source

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
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Subtitle")
        if let consumeRecord = consumeRecordsAtIndexPath(indexPath) {
//            cell.textLabel <- consumeRecord
        }

        return cell
    }
}
