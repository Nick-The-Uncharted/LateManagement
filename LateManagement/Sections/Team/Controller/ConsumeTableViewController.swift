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
    
    // MARK: Actions
    
    @IBAction func cancelButtonTouched(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTouched(sender: UIBarButtonItem) {
        let values = self.form.values()
        if let name = values["name"] as? String,
            amount = values["amount"] as? Int {
            dismissCallBack?(name, amount)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.form +++ Section()
            <<< TextRow("name") {
                row in
                row.title = "事项"
            }
            <<< IntRow("amount") {
                row in
                row.title = "金额"
        }
    }

    // MARK: - Table view data source
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
