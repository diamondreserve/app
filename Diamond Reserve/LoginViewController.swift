//
//  LoginViewController.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 28.09.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import AWSCore
import AWSDynamoDB
import SwiftHash
import MBProgressHUD
import SwiftyJSON


class LoginViewController: BaseVC {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var frameView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        frameView.layer.borderWidth = 1
        frameView.layer.borderColor = UIColor.white.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func rememberMeTapped(_ sender: Any) {
        rememberMeButton.isSelected = !rememberMeButton.isSelected
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func loginTapped(_ sender: Any) {
        
        if(emailText.text! == "" || passwordText.text! == "" ){
            displayAlert(message: "Please fill all the fields in!")
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        UserManager.sharedInstance.login(id: emailText.text!, completion: {(_ success : Bool, _ userJson: JSON?) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                let user = User(userJson!)
                if(user.password == MD5(self.passwordText.text!)) {
                    UserDefaults.standard.set(user.userId, forKey: "userId")
                    UserDefaults.standard.set(user.full_name, forKey: "fullname")
                    
                    let arn:String? = UserDefaults.standard.string(forKey: "endpointArn")
                    user.arn = arn
                    UserManager.sharedInstance.user = user
                    UserManager.sharedInstance.saveCurrentUser(userJson: userJson!)
                    
                    let parameters = [
                        "arn": arn ?? ""
                    ]
                    UserManager.sharedInstance.updateUser(user_id: (user.userId)!, bodyParams: parameters, completion: { (_ success: Bool, _ user: User?) in
                        if success {
                            DispatchQueue.main.async(execute: {
                                self.performSegue(withIdentifier: "showWelcomeVC", sender: self)
                            })
                        }
                    })
                }
                else {
                    self.displayAlert(message: "Incorrect credentials, please try again.")
                }
            }
        })
        
        /*
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDbObjectMapper.load(Users.self, hashKey: emailText.text ?? "", rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                self.displayAlert(message: "Connection problem, please try later")
            } else if (task.result as? Users) != nil {
                let user: Users = task.result as! Users
                
                if(user.password == MD5(self.passwordText.text!)) {
                    DiamondManager.sharedInstance.user = user
                    UserDefaults.standard.set(user.userId, forKey: "userId")
                    UserDefaults.standard.set(user.full_name, forKey: "fullname")
                    
                    let arn:String? = UserDefaults.standard.string(forKey: "endpointArn")
                    user.arn = arn
                    dynamoDbObjectMapper.save(user, completionHandler: {(error: Error?) -> Void in
                        if let error = error {
                            print(" Amazon DynamoDB Save Error: \(error)")
                            return
                        }
                        print("ARN was updated.")
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "showWelcomeVC", sender: self)
                        })
                    })
                }
                else {
                    self.displayAlert(message: "Incorrect credentials, please try again.")
                }
            }
            else if (task.result as? Users) == nil {
                self.displayAlert(message: "Incorrect credentials, please try again.")
            }
            return nil
        })
 
 */
    }
    
}
