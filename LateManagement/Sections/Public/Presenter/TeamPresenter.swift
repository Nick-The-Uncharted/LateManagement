//
//  TeamPresenter.swift
//  LateManagement
//
//  Created by administrasion on 7/12/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation

extension Team: AvatarPresentable, ContentPresentable, TitlePresentable {
    var title: String {
        return self.name
    }
    
    var content: String {
        return self.name
    }
}