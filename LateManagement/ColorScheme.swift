//
//  ColorScheme.swift
//  WhyFi
//
//  Created by administrasion on 6/17/16.
//  Copyright © 2016 Hch. All rights reserved.
//

import Foundation
import ChameleonFramework

class ColorScheme {
    static var defaultScheme = ColorScheme()
    
    let primaryColor = UIColor.flatSandColorDark()
    let secondaryColor = UIColor.flatWhiteColor()
    let postiveColor = UIColor.flatSkyBlueColor()
    let negativeColor = UIColor.flatWatermelonColor()
    let highLightColor = UIColor.flatMintColorDark()
    
    func updateGlobalSchema() {
        UINavigationBar.appearance().barTintColor = self.primaryColor
        UINavigationBar.appearance().tintColor = UIColor(contrastingBlackOrWhiteColorOn: self.primaryColor, isFlat: true)
        UITabBar.appearance().barTintColor = self.primaryColor
    }
}