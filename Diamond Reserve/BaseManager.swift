//
//  BaseTaskController.swift
//  Radioish
//
//  Created by alessandro on 12/29/16.
//  Copyright © 2016 Loewen. All rights reserved.
//

import Foundation
import Alamofire

class BaseManager {
    
    let baseURL = "http://localhost:5000/api/"
//    let baseURL = "https://diamond-reserve.herokuapp.com/api/"

    
    
    var simpleManager: SessionManager?
    var manager: SessionManager?
    
    enum Response {
        case success
        case failure
        case noConnection
    }
    
    init() {
        self.configureInstance(UserManager.loadToken())
    }

    func configureInstance(_ token: String) {
        
        let bearer = "Bearer \(token)"
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization" : bearer]
        self.manager = SessionManager(configuration: configuration)
        
        let simpleConfiguration = URLSessionConfiguration.default
        self.simpleManager = SessionManager(configuration: simpleConfiguration)
        
    }
}
