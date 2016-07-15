//
//  ErrorHandlerCenter.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandlerCenter {
    static func handleError(error: MyError, sender: UIViewController? = nil) {
        switch error {
        case .NoEmail:
            break
        case .WrongPassword:
            LoadingAnimation.showAndDismiss("密码错误")
        default:
            LoadingAnimation.showAndDismiss("出现未知错误")
        }
    }
}