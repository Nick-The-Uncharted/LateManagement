//
//  CustomTabBarController.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.requestSetup()
        }
    }
    
    func requestSetup() {
        let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        if let loginViewController = loginStoryboard.instantiateInitialViewController() {
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
        
    }
    
    static func becomeRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabViewController = storyboard.instantiateInitialViewController() {
            UIApplication.sharedApplication().keyWindow?.rootViewController = tabViewController
        }
    }
}
