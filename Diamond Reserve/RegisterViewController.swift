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

class RegisterViewController: BaseVC, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameText: UITextField!
    @IBOutlet weak var cityCountryText: UITextField!
    @IBOutlet weak var companyText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var frameView: UIView!
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.white.cgColor
        frameView.layer.borderWidth = 1
        frameView.layer.borderColor = UIColor.white.cgColor
        registerForKeyboardNotifications()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        
        
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            let actualOrigin = frameView.convert(activeField.frame.origin, to: self.view)
            let actualFrame = frameView.convert(activeField.frame, to: self.view)
           // if (!aRect.contains(actualOrigin)){
                self.scrollView.scrollRectToVisible(actualFrame, animated: true)
            //}
        }
    }

    
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
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
