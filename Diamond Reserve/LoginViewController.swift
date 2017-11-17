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
import Firebase


class LoginViewController: BaseVC, UITextFieldDelegate {
    
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
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        view.endEditing(true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
    }
    

    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
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
        
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (user, error) in
            if ((error) != nil) {
                MBProgressHUD.hide(for: self.view, animated: true)
                var message = (error?.localizedDescription)!
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        message = "Please make sure to use a valid email"
                        break
                    case .userNotFound:
                        message = "We couldn't find that email"
                        break
                    case .wrongPassword:
                        message = "Wrong password"
                        break
                    default:
                        message = (error?.localizedDescription)!
                    }
                }
                CommonMethods.showAlert(withTitle: "Hmm...", message: message, andCancelButtonTitle: "OK", with: nil)
                return
            }
            self.getUserDataFromServer()
        }
    }
    
    func getUserDataFromServer(){
        
        UserManager.sharedInstance.login(id: emailText.text!, completion: {(_ success : Bool, _ userJson: JSON?) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if success {
                let user = User(userJson!)
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
        })
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        let lowercaseCharRagne = string.rangeOfCharacter(from: NSCharacterSet.lowercaseLetters)
////        if (lowercaseCharRagne.location != NSNotFound) {
////
////            return false;
////        }
//        reutnr
//    }
    
}
