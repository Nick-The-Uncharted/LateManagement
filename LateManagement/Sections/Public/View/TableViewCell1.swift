//
//  TableViewCell1.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit

class TableViewCell1: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    func updateWithPresenter(presenter: protocol<TitlePresentable, AvatarPresentable, ContentPresentable>) {
        presenter.fillImageViewWithAvatar(self.avatarImageView)
        presenter.fillLabelWithTitle(self.titleLabel)
        presenter.fillLabelWithContent(self.contentLabel)
    }
    
}
