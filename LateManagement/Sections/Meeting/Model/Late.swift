//
//  Late.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation

class Late {
    var user: User
    var duration: Int
    
    init(user: User, duration: Int) {
        self.user = user
        self.duration = duration
    }
}