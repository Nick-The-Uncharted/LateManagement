//
//  LoginViewController.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import Material

class LoginTableViewController: UITableViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    @IBAction func loginButtonTouched(sender: UIButton) {
        User.login(emailTextField.text!, password: passwordTextField.text!) {user, error in
            if let error = error {
                ErrorHandlerCenter.handleError(error, sender: self)
            } else if let user = user {
                if user.teams.isEmpty {
                    self.performSegueWithIdentifier("showAddTeam", sender: nil)
                } else {
                    CustomTabBarController.becomeRootViewController()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avatarImageView.setImageByURL(NSURL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1468323122808&di=4df1db5565c01157cc1ddf8a3683c99c&imgtype=jpg&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2015-01-07%2F231358320.jpg")!)
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorStyle = .None
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        
        self.setup()
    }
    
    func setup() {
        self.emailTextField.placeholder = "邮箱"
        self.passwordTextField.placeholder = "密码"
    }
}

