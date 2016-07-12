//
//  MoneyPoolTableViewCell.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class MoneyPoolTableViewCell: UITableViewCell {
    @IBOutlet weak var moneyCntLabel: UILabel!
    var consumeButtonTouchedCallback: SimpleBlock?
    
    @IBAction func consumeButtonTouched(sender: UIButton) {
        consumeButtonTouchedCallback?()
    }
}
