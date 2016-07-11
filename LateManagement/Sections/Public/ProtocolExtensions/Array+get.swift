//
//  Array+get.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation

extension Array {
    func get(index: Int) -> Element? {
        guard index < self.count else {return nil}
        return self[index]
    }
}