//
//  HomeViewController.swift
//  Diamonds on Tap
//
//  Created by PSIHPOK on 12/7/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import AWSSNS
import AWSCore
import AWSS3
import SDWebImage

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var home_title: String?

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shapeImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var alertCtrl: UIAlertController?
    var imagePicker: UIImagePickerController?
    var photo: UIImage?
    var localPath: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButton.isHidden = false// !(UserManager.sharedInstance.user?.is_admin)!
        if home_title != nil {
            editTextView.text = home_title!
        }
        let url = S3BucketUrl + "home.jpg"
        imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "BLACK_IV_FMX"))
        
        UserManager.sharedInstance.getHomeText { (_ success: Bool, title: String?) in
            if success {
                self.home_title = title
                self.editTextView.text = title
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        editTextView.layer.borderColor = UIColor.white.cgColor
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        editTextView.layer.borderColor = UIColor.clear.cgColor
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func moveNext(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabbarVC: TabbarViewController? = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as? TabbarViewController
        mainTabbarVC?.selectedIndex = 0 // self.currentPageNumber
        
        let mainViewController: MainSideMenuController = (storyboard.instantiateViewController(withIdentifier: "MainSideMenuVC") as? MainSideMenuController)!
        mainViewController.rootViewController = mainTabbarVC
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        window?.rootViewController = mainViewController
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: { _ in })
    }
    
    
    @IBAction func editAction(_ sender: Any) {
        cameraButton.isHidden = false
        editTextView.isEditable = true
        saveButton.isHidden = false
        editTextView.becomeFirstResponder()
        editTextView.text = ""
        editButton.isHidden = true
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        setupAlertCtrl()
        present(alertCtrl!, animated: true, completion: nil)
    }
    

    @IBAction func saveAction(_ sender: Any) {
        uploadImage()
    }
    
    
    //***************  Pick and Uploading Photo  ******************
    
    func setupAlertCtrl() {
        alertCtrl = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        //Create an action
        let camera = UIAlertAction(title: "From camera", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.handleCamera()
        })
        let imageGallery = UIAlertAction(title: "From Photo Library", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.handleImageGallery()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            // [self dismissViewControllerAnimated:YES completion:nil];
        })
        //Add action to alertCtrl
        alertCtrl!.addAction(camera)
        alertCtrl!.addAction(imageGallery)
        alertCtrl!.addAction(cancel)
    }
    
    
    func handleCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alert = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        imagePicker!.sourceType = .camera
        present(imagePicker!, animated: true, completion: nil)
    }
    
    func handleImageGallery() {
        imagePicker = UIImagePickerController()
        imagePicker!.sourceType = .photoLibrary
        imagePicker!.delegate = self
        present(imagePicker!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        photo = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.image = photo
        
        let uploadFileURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName = uploadFileURL.lastPathComponent
        //        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        localPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageName!)
        do {
            let data = UIImageJPEGRepresentation(photo!, 0.3)
            try data!.write(to: localPath!)
        } catch _ {
        }
        dismiss(animated:true, completion:nil)
        
    }
    
    func uploadImage(){
        
        if localPath == nil {
            shapeImageView.isHidden = false
            shapeImageView.loadGif(name: "loading")
            UserManager.sharedInstance.updateHomeText(text: self.editTextView.text, completion: { (_ success: Bool) in
                self.shapeImageView.isHidden = true
                if success {
                    CommonMethods.showAlert(withTitle: "Upload Text", message: "Text was saved successfully", andCancelButtonTitle: "OK", with: nil)
                } else {
                    CommonMethods.showAlert(withTitle: "Hmm...", message: "Faild to save text", andCancelButtonTitle: "OK", with: nil)
                }
            })
            return
        }
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = S3BucketName
        uploadRequest?.key = "home.jpg"
        uploadRequest?.body = localPath!
        uploadRequest?.contentType = "image/jpeg"
        uploadRequest?.acl = .publicRead
        
        shapeImageView.isHidden = false
        shapeImageView.loadGif(name: "loading")
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error uploading: \(String(describing: uploadRequest?.key)) Error: \(error)")
                    }
                } else {
                    print("Error uploading: \(String(describing: uploadRequest?.key)) Error: \(error)")
                }
                self.shapeImageView.isHidden = true
                return nil
            }
            
            _ = task.result
            print("Upload complete for: \(String(describing: uploadRequest?.key))")
            
            print(self.editTextView.text)
            
            UserManager.sharedInstance.updateHomeText(text: self.editTextView.text, completion: { (_ success: Bool) in
                self.shapeImageView.isHidden = true
                if success {
                    CommonMethods.showAlert(withTitle: "Upload Photo and Text", message: "Photo and Text was saved successfully", andCancelButtonTitle: "OK", with: nil)
                } else {
                    CommonMethods.showAlert(withTitle: "Hmm...", message: "Faild to save image and text", andCancelButtonTitle: "OK", with: nil)
                }
            })
          
            return nil
        })
    }
    

}
