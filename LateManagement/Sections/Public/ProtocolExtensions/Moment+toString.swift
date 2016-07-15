//
//  Moment+toString.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import SwiftMoment

extension Moment {
    func toString(dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss'Z'") -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.stringFromDate(self.date)
    }
}