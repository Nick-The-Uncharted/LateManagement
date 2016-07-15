//
//  LatePresenter.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import UIKit

extension Punishment: AvatarPresentable, TitlePresentable, ContentPresentable {
    var avatarURL: NSURL {
        return self.user.avatarURL
    }
    
    var title: String {
        return self.user.name
    }
    
    var content: String {
        return "\(self.total)元"
    }
    
    
    func fillLabelWithTitle(label: UILabel) {
        label.font = UIFont.systemFontOfSize(16)
        label.text = self.title
        
    }
    
    func fillLabelWithContent(label: UILabel) {
        label.text = self.content
        label.textColor = UIColor.flatRedColor()
    }
}