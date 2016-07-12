//
//  CustomStringConvertible+Operator.swift
//  MiCourse
//
//  Created by administrasion on 12/6/15.
//  Copyright © 2015 KeJian. All rights reserved.
//

import Foundation
import UIKit

infix operator <-  {precedence 90}

func <- <T: CustomStringConvertible>(label: UILabel, object: T) {
    label.text = object.description
}

func <- (label: UILabel, string: String) {
    label.text = string
}

func + <T: CustomStringConvertible>(object: T, string: String) -> String {
    return "\(object)" + string
}


func + <T: CustomStringConvertible>(string: String, object: T) -> String {
    return string + "\(object)"
}
