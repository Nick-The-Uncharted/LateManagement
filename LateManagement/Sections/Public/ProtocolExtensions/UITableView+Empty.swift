//
//  UITableView+Empty.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

extension UITableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    public func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "没数据呢")
    }
    
    public func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
}
