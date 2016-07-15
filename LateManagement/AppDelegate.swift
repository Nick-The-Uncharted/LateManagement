//
//  AppDelegate.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func showLoginVC() {
        let loginStoryboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        if let loginViewController = loginStoryboard.instantiateInitialViewController() {
            self.window?.rootViewController = loginViewController
        }
        
    }

    func requestLogin() {
        User.tryLogin {
            user, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error)
                self.showLoginVC()
            } else if let user = user {
                User.loginUser = user
                if user.teams.isEmpty {
                    let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
                    let addTeamVC = storyboard.instantiateViewControllerWithIdentifier("AddTeamViewController")
                    self.window?.rootViewController = addTeamVC
                }
            }
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        NSUserDefaults.standardUserDefaults().removeObjectForKey("lastLoginEmail")
        ColorScheme.defaultScheme.updateGlobalSchema()
        
//        for cookie in NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies! {
//            NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
//        }
        self.requestLogin()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

