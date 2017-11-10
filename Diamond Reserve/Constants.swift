//
//  Constants.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/11/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import Foundation
import UIKit

let S3BucketName = "diamondreserve-userfiles-mobilehub-952888115/public"
let S3BucketUrl = "https://s3.amazonaws.com/diamondreserve-userfiles-mobilehub-952888115/public/"

let SNSPlatformApplicationArn = "arn:aws:sns:us-east-1:247454595621:app/APNS/DiamondProduction"
//let SNSPlatformApplicationArn = "arn:aws:sns:us-east-1:247454595621:app/APNS_SANDBOX/diamond_develop2"

//let API_BASE_URL = "http://localhost:5000/api/"
    let API_BASE_URL = "https://diamond-reserve.herokuapp.com/api/"

let DIAMOND_THEME_COLOR =           UIColor(red: 0, green: 0, blue: 0)
let SCREEN_WIDTH : CGFloat =        UIScreen.main.bounds.width
let SCREEN_HEIGHT : CGFloat =       UIScreen.main.bounds.height

var scale : Float = 2

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}




