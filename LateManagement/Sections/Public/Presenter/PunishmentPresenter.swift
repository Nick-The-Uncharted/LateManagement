//
//  LatePresenter.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation

extension Punishment: AvatarPresentable, TitlePresentable, ContentPresentable {
    var avatarURL: NSURL {
        return self.user.avatarURL
    }
    
    var title: String {
        return self.user.name
    }
    
    var content: String {
        return "￥\(self.count)"
    }
}