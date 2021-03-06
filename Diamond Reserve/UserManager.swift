//
//  LocationManager.swift
//  Recmend
//
//  Created by PSIHPOK on 6/24/17.
//  Copyright © 2017 PSIHPOK. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserManager: BaseManager {
    
    static var sharedInstance = UserManager()
    var user : User?
    var adminARNS : [String]?
    
    let User_URL = API_BASE_URL + "users/"

    
    static func loadToken() -> String {
        return "token"
    }
    
    func resetUser(){
        user = nil
        UserDefaults.standard.removeObject(forKey: "userJson")
    }
    
    func saveCurrentUser(userJson: JSON){
        let defaults = UserDefaults.standard
        defaults.setValue(userJson.rawString()!, forKey: "userJson")
    }
    
    func loadCurrentUser(){
        if let userJsonString = UserDefaults.standard.value(forKey: "userJson") {
            let userJson = JSON.parse(userJsonString as! String)
            self.user = User(userJson)
        }
    }
    
    func login(id: String, completion: @escaping (_ success : Bool, _ user: JSON?) -> Void) {
        
        let parameters: Parameters = [
            "user_id": id
        ]
        
        let url = User_URL + "login"
        manager!.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false, nil)
                    return
                }
                
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["code"] == 404 {
                        CommonMethods.showAlert(withTitle: "Hmm...", message: "Email is wrong", andCancelButtonTitle: "OK", with: nil)
                        completion(false, nil)
                    } else {
                        completion(true, json)
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    
    func getAdminARNs(completion: @escaping (_ success : Bool, _ adminARNs: [String]?) -> Void) {
        
        let url = User_URL + "admins"
        manager!.request(url, method: .get, parameters: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false, nil)
                    return
                }
                if let data = response.result.value {
                    let jsonArray = JSON(data).arrayValue
                    completion(true, jsonArray.map({$0["arn"].stringValue}))
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    func getHomeText(completion: @escaping (_ success : Bool, _ homeText: String?) -> Void) {
        
        let url = User_URL + "home_text"
        manager!.request(url, method: .get, parameters: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false, nil)
                    return
                }
                if let data = response.result.value {
                    let json = JSON(data)
                    let homeText = json["home_title"].string
                    completion(true, homeText)
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    func updateHomeText(text: String, completion: @escaping (_ success : Bool) -> Void) {
        
        let parameters: Parameters = [
            "home_title": text
        ]
        
        let url = User_URL + "home_text"
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false)
                    return
                }
                if let data = response.result.value {
                    let json = JSON(data)
                    print(json)
                    if json == "success" {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    
    func updateUser(user_id: String, bodyParams: Parameters, completion: @escaping (_ success : Bool, _ user: User?) -> Void) {
        
        let url = User_URL + user_id
        Alamofire.request(url, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    completion(false, nil)
                    return
                }
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["code"] == 404 {
                        CommonMethods.showAlert(withTitle: "Hmm...", message: "Wrong User ID", andCancelButtonTitle: "OK", with: nil)
                        completion(false, nil)
                    } else {
                        completion(true, User(json))
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    
    func registerUser(bodyParams: Parameters, completion: @escaping (_ success : Bool, _ user: JSON?) -> Void) {
        
        let url = User_URL
        Alamofire.request(url, method: .post, parameters: bodyParams, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if response.result.error != nil {
                    print(response.result.error as Any)
                    CommonMethods.showAlert(withTitle: "Hmm...", message: "Connect problem please try again later", andCancelButtonTitle: "OK", with: nil)
                    completion(false, nil)
                    return
                }
                if let data = response.result.value {
                    let json = JSON(data)
                    if json["code"] == 404 {
                        CommonMethods.showAlert(withTitle: "Hmm...", message: "User is already registered", andCancelButtonTitle: "OK", with: nil)
                        completion(false, nil)
                    } else {
                        completion(true, json)
                    }
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }

    
    
    
    
}
