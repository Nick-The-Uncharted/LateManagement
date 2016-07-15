//
//  Int + Format.swift
//  LateManagement
//
//  Created by administrasion on 7/14/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation

extension Int {
    var twoBit: String {
        return String(format: "%02d", arguments: [self])
    }
}