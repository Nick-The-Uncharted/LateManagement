//
//  LoadingAnimation.swift
//  LateManagement
//
//  Created by administrasion on 7/13/16.
//  Copyright © 2016 NJU. All rights reserved.
//

import Foundation
import PKHUD

class LoadingAnimation {
    static var showCnt = 0
    static func show(text: String = "加载中……") {
        showCnt += 1
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: text)
        PKHUD.sharedHUD.show()
    }
    
    static func showAndDismiss(text: String, delay: Double = 0.5) {
        LoadingAnimation.show(text)
        PKHUD.sharedHUD.hide(afterDelay: delay) {
            _ in
            self.showCnt -= 1
        }
    }
    
    static func dismiss() {
        showCnt -= 1
//        if showCnt == 0 {
            PKHUD.sharedHUD.hide(animated: true, completion: nil)
//        }
    }
}