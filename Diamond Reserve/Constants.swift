//
//  Constants.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/11/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import Foundation
import UIKit



let DIAMOND_THEME_COLOR =           UIColor(red: 0, green: 0, blue: 0)
let SCREEN_WIDTH : CGFloat =        UIScreen.main.bounds.width
let SCREEN_HEIGHT : CGFloat =       UIScreen.main.bounds.height



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
