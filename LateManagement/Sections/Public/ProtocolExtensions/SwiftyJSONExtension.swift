//
//  SwiftyJSONExtension.swift
//  MiCourse
//
//  Created by administrasion on 12/14/15.
//  Copyright © 2015 KeJian. All rights reserved.
//

import SwiftyJSON
import SwiftMoment

extension JSON {
    var stringProperty: String {
        return self.stringValue ?? "error"
    }
    
    var intProperty: Int {
        return self.int ?? Int(self.string ?? "") ?? 0
    }
    
    var doubleProperty: Double {
        return self.double ?? Double(self.string ?? "") ?? 0
    }
    
    var boolProperty: Bool {
        if let bool = self.bool {
            return bool
        } else if let i = self.int {
            return i == 1
        } else if let str = self.string {
            return str == "true" || str == "1"
        } else {
            return false
        }
    }
    
    var stringArrayProperty: [String]{
        return (self.arrayObject as? [String]) ?? []
    }
    
    var urlProperty: NSURL {
        return self.URL ?? NSURL()
    }
    
    var time: Moment {
        return moment(self.stringProperty) ?? moment()
    }
    
    func notExists() -> Bool {
        return self.type == .Null
    }
    
    func isExists() -> Bool {
        return self.type != .Null
    }
}