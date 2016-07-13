//
//  MyError.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation

enum MyError: ErrorType {
    case Unknown(String)
    case ServerError(String)
    
    // login erorr
    case NetworkError, WrongPassword
    case NoEmail
}