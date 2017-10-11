//
//  Diamonds.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 09.10.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import Foundation
import AWSCore
import AWSDynamoDB

class Diamonds: AWSDynamoDBObjectModel {
    var diamondId: String?
    var name: String?
    var price: String?
    var type: String?
    var category: String?

    
    class func dynamoDBTableName() -> String {
        return "Diamonds"
    }
    
    class func hashKeyAttribute() -> String {
        return "diamondId"
    }
}
