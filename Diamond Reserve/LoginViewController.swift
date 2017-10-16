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
        
        // Temporarily
        self.performSegue(withIdentifier: "showWelcomeVC", sender: self)
        return
        
        
        if(emailText.text! == "" || passwordText.text! == "" ){
            displayAlert(message: "Please fill all the fields in!")
            return
        }
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDbObjectMapper.load(Users.self, hashKey: emailText.text ?? "", rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                self.displayAlert(message: "Connection problem, please try later")
            } else if (task.result as? Users) != nil {
                let user: Users = task.result as! Users
                
                if(user.password == MD5(self.passwordText.text!)) {
                    //UserDefaults.standard.set(task.result, forKey: "currentUser")
                    DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "showWelcomeVC", sender: self)
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
    }
    
}
