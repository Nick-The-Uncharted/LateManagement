//
//  UIImage+ SetImageView.swift
//  LateManagement
//
//  Created by administrasion on 7/11/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImageByURL(url: NSURL) {
        self.kf_setImageWithURL(url)
    }
}