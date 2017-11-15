//
//  RegisterViewController.swift
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

class RegisterViewController: BaseVC {

    @IBOutlet weak var fullNameText: UITextField!
    @IBOutlet weak var cityCountryText: UITextField!
    @IBOutlet weak var companyText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var frameView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.white.cgColor
        frameView.layer.borderWidth = 1
        frameView.layer.borderColor = UIColor.white.cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
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

    @IBAction func OnSubmit(_ sender: Any) {
        if(emailText.text! == "" || fullNameText.text! == "" || passwordText.text! == "" || companyText.text! == "" || cityCountryText.text! == "" || confirmText.text! == ""){
            displayAlert(message: "Please fill all the fields in!")
            return
        }
        if(passwordText.text != confirmText.text) {
            displayAlert(message: "Passwords do not match!")
            return
        }
        
        let arn:String? = UserDefaults.standard.string(forKey: "endpointArn")
        
        let params = [
            "id": emailText.text!,
            "email": emailText.text!,
            "password": MD5(passwordText.text!),
            "full_name": fullNameText.text!,
            "company_name": companyText.text!,
            "city": cityCountryText.text!,
            "arn": arn ?? ""
        ]
        
        let successAlert = UIAlertController(title: "Success", message: "Successfully registered", preferredStyle: UIAlertControllerStyle.alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserManager.sharedInstance.registerUser(bodyParams: params) { (_ success: Bool, _ userJson: JSON?) in
            if success {
                DispatchQueue.main.async(execute: {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    UserManager.sharedInstance.user = User(userJson!)
                    UserManager.sharedInstance.saveCurrentUser(userJson: userJson!)
                    self.present(successAlert, animated: true, completion: nil)
                })
            }
        }
        

    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    
}
