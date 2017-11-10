//
//  Diamonds.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 09.10.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import Foundation
import SwiftyJSON

class Diamonds: NSObject {
    var id: String?
    var clarity: String?
    var diamond360: String?
    var shape: String?
    var weight: NSNumber?
    var color: String?
    var price: NSNumber?
    var image: String?
    var certificate: String?
    var certificate_image: String?
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
    var total_reserved: Bool?
    var user: String?
    var status: String?
    var user_reserved_date: Date?
    var total_reserved_date: Date?
    var user_reject_reason: String?
    
    init(_ json: JSON) {
        
        id = json["vendo_number"].string
        shape = json["shape"].string
        weight = json["weight"].number
        color = json["color"].string
        clarity = json["clarity"].string
        measurements = json["measurements"].string
        diamond360 = json["diamond360"].string
        price = json["price"].number
        image = json["diamond_image"].string
        certificate = json["certificate_number"].string
        comments = json["comments"].string
        culet_size = json["culet_size"].string
        cut_grade = json["cut_grade"].string
        fluorescence_intensity = json["fluorescence_intensity"].string
        girdle_thin = json["girdle_thin"].string
        girdle_thick = json["girdle_thick"].string
        lab = json["lab"].string
        polish = json["polish"].string
        symmetry = json["symmetry"].stringValue
        certificate_image = json["certificate_image"].stringValue
        depth = json["depth"].number
        total_reserved = json["total_reserved"].boolValue
        user = json["user"].string
        status = json["user_state"].string
        user_reject_reason = json["user_reject_reason"].string
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let cdate = json["user_reserved_date"].string {
            user_reserved_date = formatter.date(from: cdate)!
        }
        if let cdate = json["total_reserved_date"].string {
            total_reserved_date = formatter.date(from: cdate)!
        }
    }
    
    
}
