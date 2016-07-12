//
//  ClosureButton.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class ClosureButton: UIButton {
    var closure: SimpleBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.addTarget(self, action: #selector(ClosureButton.buttonDidTouched), forControlEvents: .TouchUpInside)
    }
    
    func buttonDidTouched() {
        self.closure?()
    }
}