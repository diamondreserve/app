//
//  User.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 08.10.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import Foundation
import AWSCore
import AWSDynamoDB

class Users: AWSDynamoDBObjectModel{
    var userId: String?
    var full_name: String?
    var company_name: String?
    var city: String?
    var country: String?
    var email: String?
    var password: String?
    var isVerified: Bool?
    class func dynamoDBTableName() -> String {
        return "Users"
    }
    
    class func hashKeyAttribute() -> String {
        return "userId"
    }
    
}
