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
        self.tabBar.tintColor = ColorScheme.defaultScheme.highLightColor
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    static func becomeRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabViewController = storyboard.instantiateInitialViewController() {
            UIApplication.sharedApplication().keyWindow?.rootViewController = tabViewController
        }
    }
}
