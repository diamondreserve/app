//
//  DiamondManager.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/25/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class DiamondManager: BaseManager {
    
    static var sharedInstance = DiamondManager()
    
    
    let Diamond_URL = API_BASE_URL + "diamonds/"
    let Reserve_URL = API_BASE_URL + "reservations/"
    
    var allDiamonds: [Diamonds]?
    var filteredDiamonds: [Diamonds] = [Diamonds]()
    var selectedDiamonds: [Diamonds] = [Diamonds]()
    
    var allReservations: [Diamonds] = [Diamonds]()
    

    var markupValues: [Float]?
    
    func saveMarkupValues() {
        UserDefaults.standard.set(markupValues, forKey: "markupValues")
    }
    
    func loadMarkupValues() {
        markupValues = (UserDefaults.standard.array(forKey: "markupValues") as? [Float]?) ?? [1, 1, 1, 1, 1]
        if markupValues == nil {markupValues = [1, 1, 1, 1, 1]}
    }

    
    func getAllDiamonds(completion: @escaping (_ success : Bool, _ diamonds: [Diamonds]?) -> Void) {
        
        let url = Diamond_URL
        let params = ["user_id": UserManager.sharedInstance.user!.userId!]
        print(params)
        manager!.request(url, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false, nil)
                    return
                }
                if let data = response.result.value {
                    print(JSON(data))
                    let diamondArray = JSON(data).arrayValue.map({Diamonds($0)})
                    completion(true, diamondArray)
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    
    func getDiamond(diamondId: String, completion: @escaping (_ success : Bool, _ diamond: Diamonds?) -> Void) {
        
        let url = Diamond_URL + diamondId
        let params = ["user_id": UserManager.sharedInstance.user!.userId!]
        manager!.request(url, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false, nil)
                    return
                }
                if let data = response.result.value {
                    print(JSON(data))
                    let json = JSON(data)
                    if json["code"] == 404 {
                        CommonMethods.showAlert(withTitle: "Diamond Deserve", message: "Diamond is already reserved, please refresh the list", andCancelButtonTitle: "OK", with: nil)
                        completion(false, nil)
                    } else {
                        let diamond = Diamonds(json)
                        completion(true, diamond)
                    }
                

                }
                
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    func updateDiamondImageLink(diamond_id: String, link: String, completion: @escaping (_ success : Bool) -> Void) {
        
        let bodyParams = ["diamond_image" : link]
        let url = Diamond_URL + diamond_id
        
        Alamofire.request(url, method: .put, parameters: bodyParams, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false)
                    return
                }
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["result"].stringValue == "success" {
                        completion(true)
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func getMarkedUpPrice(origin: Float) -> Float {
        
        var index: Int = 1
        if origin < 2499 {
            index = 0
        } else if origin < 9999 {
            index = 1
        } else if origin < 24999 {
            index = 2
        } else if origin < 99999 {
            index = 3
        } else {
            index = 4
        }
        
        return origin * markupValues![index]
    }
    
    
    func getAllReservations(completion: @escaping (_ success : Bool, _ diamonds: [Diamonds]?) -> Void) {
        
        let url = Reserve_URL
        let params = ["user_id": UserManager.sharedInstance.user!.userId!]
        print(params)
        manager!.request(url, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false, nil)
                    return
                }
                if let data = response.result.value {
                    print(JSON(data))
                    let diamondArray = JSON(data).arrayValue.map({Diamonds($0)})
                    completion(true, diamondArray)
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    
    func getReservation(user_id: String, diamond_id: String, completion: @escaping (_ success : Bool, _ diamond: Diamonds?) -> Void) {
        
        let url = Reserve_URL + "detail"
        let params = ["user_id": user_id,
                      "diamond_id": diamond_id]
        print(params)
        manager!.request(url, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false, nil)
                    return
                }
                if let data = response.result.value {
                    print(JSON(data))
                    let diamond = Diamonds(JSON(data))
                    completion(true, diamond)
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    
    
    func requestReserve(user_id: String, diamond_id: String, completion: @escaping (_ success : Bool) -> Void) {
        
        let url = Reserve_URL + "request"
        let bodyParams =
            ["user_id": user_id,
             "diamond_id": diamond_id]
        Alamofire.request(url, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false)
                    return
                }
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["result"].stringValue == "fail" {
                        CommonMethods.showAlert(withTitle: "Diamond Reserve", message: json["message"].stringValue, andCancelButtonTitle: "OK", with: nil)
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func acceptReserve(user_id: String, diamond_id: String, completion: @escaping (_ success : Bool) -> Void) {
        
        let url = Reserve_URL + "accept"
        let bodyParams =
            ["user_id": user_id,
             "diamond_id": diamond_id]
        Alamofire.request(url, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false)
                    return
                }
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["result"].stringValue == "fail" {
                        CommonMethods.showAlert(withTitle: "Diamond Reserve", message: json["message"].stringValue, andCancelButtonTitle: "OK", with: nil)
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func rejectReserve(user_id: String, diamond_id: String, reject_reason: String, completion: @escaping (_ success : Bool) -> Void) {
        
        let url = Reserve_URL + "reject"
        let bodyParams =
            ["user_id": user_id,
             "diamond_id": diamond_id,
             "reject_reason":reject_reason]
        Alamofire.request(url, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false)
                    return
                }
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["result"].stringValue == "success" {
                        completion(true)
                        print(json["message"])
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    
    
    func cancelReserve(diamond_id: String, completion: @escaping (_ success : Bool) -> Void) {
        
        let url = Reserve_URL + "cancel"
        let bodyParams =
            ["diamond_id": diamond_id]
        Alamofire.request(url, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false)
                    return
                }
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["result"].stringValue == "success" {
                        completion(true)
                        print(json["message"])
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    
    
}
