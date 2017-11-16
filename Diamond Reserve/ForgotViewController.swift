//
//  ForgotViewController.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 28.09.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class ForgotViewController: UIViewController {

    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.white.cgColor
        frameView.layer.borderWidth = 1
        frameView.layer.borderColor = UIColor.white.cgColor
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
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

    @IBAction func submitResetAction(_ sender: Any) {
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        Auth.auth().sendPasswordReset(withEmail: emailText.text!) { (error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if (error != nil) {
                CommonMethods.showAlert(withTitle: "Diamond Deserve", message: (error?.localizedDescription)!, andCancelButtonTitle: "OK", with: nil)
            } else {
                let successAlert = UIAlertController(title: "Success", message: "Sent, please check your email", preferredStyle: UIAlertControllerStyle.alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(successAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
