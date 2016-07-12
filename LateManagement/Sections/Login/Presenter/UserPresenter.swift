//
//  UserPresenter.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation

extension User: AvatarPresentable, TitlePresentable, ContentPresentable {
    var title: String {
        get {
            return self.name
        }
        
        set {
            self.name = newValue
        }
    }
    
    var content: String {
        return self.team?.name ?? "no content"
    }
}