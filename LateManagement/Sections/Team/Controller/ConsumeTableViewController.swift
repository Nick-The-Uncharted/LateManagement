//
//  ConsumeTableViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import Eureka

class ConsumeTableViewController: FormViewController {
    var dismissCallBack: ((String, Int) -> Void)?
    var maxAmount = 0
    
    // MARK: Actions
    
    @IBAction func cancelButtonTouched(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        let values = self.form.values()
        if let name = values["name"] as? String,
            amount = values["amount"] as? Int {
            if name.isEmpty {
                LoadingAnimation.showAndDismiss("事项不能为空", delay: 1)
                return
            }
            
            if amount <= 0 {
                LoadingAnimation.showAndDismiss("金额必须为正数", delay: 1)
                return
            } else if amount > self.maxAmount {
                LoadingAnimation.showAndDismiss("消费金额不能大于队伍余额\(self.maxAmount)", delay: 1)
                return
            }
            
            dismissCallBack?(name, amount)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            LoadingAnimation.showAndDismiss("事项或金额不能为空", delay: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.form +++ Section()
            <<< TextRow("name") {
                row in
                row.title = "事项"
                row.placeholder = "消费原因"
            }
            <<< IntRow("amount") {
                row in
                row.title = "金额"
                row.placeholder = "消费金额"
        }
    }

    // MARK: - Table view data source
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
