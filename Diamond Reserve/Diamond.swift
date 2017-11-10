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

class Diamond: AWSDynamoDBObjectModel {
    var id: String?
    var clarity: String?
    var diamond360: String?
    var shape: String?
    var weight: NSNumber?
    var color: String?
    var price: NSNumber?
    var image: String?
    var certificate: String?
    var comments : String?
    var culet_size: String?
    var cut_grade: String?
    var fluorescence_intensity: String?
    var girdle_thick: String?
    var girdle_thin: String?
    var lab: String?
    var measurements: String?
    var polish: String?
    var symmetry: String?
    var depth: NSNumber?
    var status: String?
    var user: String?
    var reserved_date_timestamp: NSNumber?
    var reject_reason: String?
    
    
    class func dynamoDBTableName() -> String {
        return "diamonds"
    }
    
    class func hashKeyAttribute() -> String {
        return "id"
    }
    
    
    
    
}
