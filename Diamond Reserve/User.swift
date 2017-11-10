//
//  User.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 08.10.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject{
    var userId: String?
    var full_name: String?
    var company_name: String?
    var city: String?
    var country: String?
    var email: String?
    var password: String?
    var isVerified: Bool?
    var arn: String?
    var is_admin: Bool?
    
    init(_ json: JSON) {
        
        userId = json["id"].string
        full_name = json["full_name"].string
        city = json["city"].string
        company_name = json["company_name"].string
        email = json["email"].string
        password = json["password"].string
        arn = json["arn"].string
        is_admin = json["is_admin"].boolValue
  
    }

    
}
