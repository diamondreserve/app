//
//  DiamondDetailViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/19/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import AWSSNS
import AWSDynamoDB
import AWSCore
import AWSS3
import SwiftyJSON


enum ReserveState {
    case ready
    case pending
    case reserved
    case rejected
}

class DiamondDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var isFromDiamondList: Bool = true
    var isFromNotification : Bool = false
    var reserveState: String = ""
    
    var diamond : Diamonds?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var diamondImageView: UIImageView!
    @IBOutlet weak var shapeImageView: UIImageView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var purchaseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var rotateButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var purchaseView: UIView!
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var acceptFullnameLabel: UILabel!
    @IBOutlet weak var acceptEmailLabel: UILabel!
    @IBOutlet weak var acceptDiamondLabel: UILabel!
    
    @IBOutlet weak var requestView: UIView!
    
    @IBOutlet weak var rejectView: UIView!
    @IBOutlet weak var rejectReasonTextView: UITextView!
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    var timer: Timer!
    var reservedDate : Date?
    
    var alertCtrl: UIAlertController?
    var imagePicker: UIImagePickerController?
    var photo: UIImage?
    var localPath: URL?
    @IBOutlet weak var cameraButton: UIButton!
    
    
    var isAdmin = (UserManager.sharedInstance.user?.is_admin)!
    
    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print((diamond?.image ?? "empty image link"))
        
        var defaultImage = UIImage(named: "round_normal")
        var shape = diamond?.shape
        if shape == "PR" {
            shape = "PRINCESS"
            defaultImage = UIImage(named: "princess_normal")
        } else if shape == "PS"{
            shape = "PEAR"
            defaultImage = UIImage(named: "pear_normal")
        } else if shape == "OV"{
            shape = "OVAL"
            defaultImage = UIImage(named: "oval_normal")
        } else if (shape == "CU" || shape == "CB"){
            shape = "CUSHION"
            defaultImage = UIImage(named: "cushion_normal")
        } else if shape == "EM"{
            shape = "EMERALD"
            defaultImage = UIImage(named: "emerald_normal")
        } else if shape == "HS"{
            shape = "HEART"
            defaultImage = UIImage(named: "heart_normal")
        } else if (shape == "RA" || shape == "SB"){
            shape = "RADIANT"
            defaultImage = UIImage(named: "radiant_normal")
        } else if shape == "MO"{
            shape = "MARQUISE"
            defaultImage = UIImage(named: "marquise_normal")
        } else if shape == "AS"{
            shape = "ASSCHER"
            defaultImage = UIImage(named: "asscher_normal")
        } else if shape == "BR"{
            shape = "ROUND"
            defaultImage = UIImage(named: "round_normal")
        }
        if diamond?.image != nil && diamond!.image! != "" {
            let imageURL = diamond!.image!
            print(imageURL)
            diamondImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "diamond_detail_default"))
            shapeImageView.isHidden = true
        } else {
            shapeImageView.image = defaultImage
        }
        
        if diamond?.diamond360 == nil || diamond!.diamond360! == "" {
            rotateButtonHeight.constant = 0
        }
        
        titleLabel.text = String.init(format: "%.2fct %@ %@, %@",(diamond?.weight?.floatValue ?? 0)!, (shape ?? ""), diamond?.color ?? "", diamond?.clarity ?? "")
        
        let price = DiamondManager.sharedInstance.getMarkedUpPrice(origin: diamond?.price?.floatValue ?? 0) * (diamond?.weight?.floatValue ?? 0)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        priceLabel.text = (price == 0) ? "" : formatter.string(from: NSNumber(value: price))
        
        setNavigationBar()
        tableViewHeight.constant = 28 * 7
        purchaseViewHeight.constant = 0
        
        if isAdmin {
            if isFromDiamondList {
                reserveState =  diamond!.total_reserved! ? "reserved" : "available"
            } else {
                reserveState = diamond!.status! // should be all "pending" or "reserved"
            }
        } else {
            reserveState = (diamond!.status != nil) ? diamond!.status! : "available"
        }
        
        if isFromDiamondList {
            reservedDate = diamond!.total_reserved_date
        } else {
            reservedDate = diamond!.user_reserved_date
        }
        
        updateReserveButton()
        startTimer()
        
        if isFromNotification {
            didPressReserverButton(0)
        }

    }
    
    
    func setNavigationBar() {
        navigationItem.title = "DIAMOND"
        
        let backItem = UIBarButtonItem(title: "BACK", style: .plain, target: self, action: #selector(backAction))
        backItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        navigationItem.leftBarButtonItem = backItem
        
        
        let rightBtn = UIBarButtonItem(image: UIImage(named:"share"), style: .plain, target: self, action: #selector(shareAction))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    func updateReserveButton() {
        
        switch reserveState {
           
            case "pending":
                reserveButton.backgroundColor = UIColor(rgb : 0xb6b6b6)
                reserveButton.setTitle("PENDING", for: .normal)
                purchaseViewHeight.constant = 0
                purchaseView.isHidden = true
                break
            
            case "rejected":
                reserveButton.setTitle("REJECTED", for: .normal)
                reserveButton.backgroundColor = UIColor(rgb : 0xD04747)
                purchaseViewHeight.constant = 0
                purchaseView.isHidden = true
                break
            
            case "reserved":
                reserveButton.setTitle("RESERVED", for: .normal)
                reserveButton.backgroundColor = UIColor(rgb : 0x0FBB32)
                purchaseViewHeight.constant = 110
                purchaseView.isHidden = false
                break
            
            default:
                reserveButton.setTitle("RESERVE", for: .normal)
                reserveButton.backgroundColor = .white
                purchaseViewHeight.constant = 0
                purchaseView.isHidden = true
                break
        }
    }
    
    func startTimer() {
        if (reserveState == "reserved" && reservedDate != nil) {
            let currentTS = Date().timeIntervalSince1970
            let expireTS = (reservedDate!.timeIntervalSince1970) + 24 * 60 * 60
            let difference = Int(expireTS - currentTS)
            if difference > 0 {
                timerView.isHidden = false
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
        }
    }
    
    func updateTimer(){
        let currentTS = Date().timeIntervalSince1970
        if reservedDate != nil {
            let expireTS = (reservedDate!.timeIntervalSince1970) + 24 * 60 * 60
            let difference = expireTS - currentTS
            if difference > 0 {
                timerLabel.text = timeString(time: difference)
            } else {
                timer.invalidate()
                timerView.isHidden = true
                // Call Available API
                reserveState = "available"
                updateReserveButton()
            }
        }
    }
    
    
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func backAction() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func shareAction() {
        
    }
    
    
    @IBAction func didPressReserverButton(_ sender: Any) {
        
        if reserveState == "available" {
            if isAdmin {
                // Accept Action Without Push notification
                DiamondManager.sharedInstance.acceptReserve(user_id: UserManager.sharedInstance.user?.userId ?? "", diamond_id: diamond!.id!) { (_ success: Bool) in
                    if success {
                        self.reserveState = "reserved"
                        self.updateReserveButton()
                    }
                }
            } else {
                requestView.isHidden = false
            }
        } else if reserveState == "pending" {
            if isAdmin {
                popupView.isHidden = false
                acceptFullnameLabel.text = " "
                UserManager.sharedInstance.login(id: diamond!.user!, completion: { (_ success: Bool, _ userJson: JSON?) in
                    if (success) {
                        self.acceptFullnameLabel.text = userJson!["full_name"].stringValue
                    }
                })
                acceptEmailLabel.text = diamond?.user
                acceptDiamondLabel.text = titleLabel.text! + " for " + priceLabel.text!
            }
        } else if reserveState == "reserved" {
            if isAdmin {
                DiamondManager.sharedInstance.cancelReserve(diamond_id: diamond!.id!) { (_ success: Bool) in
                    if success {
                        self.reserveState = "available"
                        self.updateReserveButton()
                        if self.timer != nil {
                            self.timer.invalidate()
                        }
                        self.timerView.isHidden = true
                    }
                }
            }
        }
    }
    
    @IBAction func requestReserveAction(_ sender: Any) {
        DiamondManager.sharedInstance.requestReserve(user_id: UserManager.sharedInstance.user!.userId!, diamond_id: diamond!.id!) { (_ success: Bool) in
            if success {
                self.reserveState = "pending"
                self.updateReserveButton()
                self.sendPN()
                self.requestView.isHidden = true
            }
        }
    }
    
    @IBAction func cancelRequestViewAction(_ sender: Any) {
        requestView.isHidden = true
    }
    
    @IBAction func acceptReserveAction(_ sender: Any) {
        DiamondManager.sharedInstance.acceptReserve(user_id: diamond!.user ?? "", diamond_id: diamond!.id!) { (_ success: Bool) in
            if success {
                self.reserveState = "reserved"
                self.updateReserveButton()
                self.sendPN()
                self.popupView.isHidden = true
                self.reservedDate = Date()
                self.startTimer()
            }
        }
    }
    
    @IBAction func cancelAcceptViewAction(_ sender: Any) {
        self.popupView.isHidden = true
    }
    
    @IBAction func rejectReserveAction(_ sender: Any) {
        self.popupView.isHidden = true
        self.rejectView.isHidden = false
        rejectReasonTextView.text = ""
        rejectReasonTextView.becomeFirstResponder()
    }
    
    @IBAction func sendRejectAction(_ sender: Any) {
        
        DiamondManager.sharedInstance.rejectReserve(user_id: diamond!.user ?? "", diamond_id: diamond!.id!, reject_reason: rejectReasonTextView.text ?? "") { (_ success: Bool) in
            if success {
                self.reserveState = "rejected"
                self.updateReserveButton()
                self.sendPN()
                self.rejectView.isHidden = true
            }
        }
     }
    
    @IBAction func backRejectAction(_ sender: Any) {
        self.popupView.isHidden = false
        self.rejectView.isHidden = true
    }
    
    
    func sendPN(){
        let sns = AWSSNS.default()
        let request = AWSSNSPublishInput()
        request?.messageStructure = "json"
        
        var action = ""
        var user_id = ""
        var message = ""
        
        if reserveState == "pending" {
            action = "reserve_request"
            user_id = UserManager.sharedInstance.user?.userId ?? ""
            message = (UserManager.sharedInstance.user?.full_name ?? "") + " is Requesting to Reserve Diamond " + (titleLabel.text ?? "")
            
        } else if reserveState == "reserved" {
            action = "accept_reserve"
            user_id = diamond?.user! ?? ""
            message = "Your request to reserve diamond " + (titleLabel.text ?? "") + " is accepted"
            
        } else if reserveState == "rejected" {
            action = "reject_reserve"
            user_id = diamond?.user! ?? ""
            message = "Your request to reserve diamond " + (titleLabel.text ?? "") + " is rejected, reason: " + (rejectReasonTextView.text ?? "")
        }

        let diamond_id = diamond?.id ?? ""
        
        let dict = ["default": "The default message",
                    "APNS": "{\"aps\":{\"alert\": \"\(message)\",\"sound\":\"default\", \"badge\":\"1\"}, \"action\":\"\(action)\", \"diamond_id\":\"\(diamond_id)\", \"user_id\":\"\(user_id)\" }",
            "APNS_SANDBOX": "{\"aps\":{\"alert\": \"\(message)\",\"sound\":\"default\", \"badge\":\"1\"}, \"action\":\"\(action)\", \"diamond_id\":\"\(diamond_id)\", \"user_id\":\"\(user_id)\" }"]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            request?.message = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
            if reserveState == "pending" {
                let arns = UserDefaults.standard.stringArray(forKey: "adminEndpointArn")
                if arns != nil && arns!.count > 0 {
                    request?.targetArn = arns![0]
                    sns.publish(request!).continueWith { (task) -> AnyObject! in
                        print("error \(String(describing: task.error)), result: \(String(describing: task.result))")
                        return nil
                    }
                }
            } else {
                UserManager.sharedInstance.login(id: diamond?.user! ?? "", completion: { (_ success: Bool, _ userJson: JSON?) in
                    if (success) {
                        print(userJson!)
                        if userJson != nil {
                            let arn = userJson!["arn"].stringValue
                            request?.targetArn = arn
                            sns.publish(request!).continueWith { (task) -> AnyObject! in
                                print("error \(String(describing: task.error)), result: \(String(describing: task.result))")
                                return nil
                            }
                        }
                    }
                })
            }

            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func showRotation360(_ sender: Any) {
        let rotationVC: RotationDiamondViewController = (storyboard?.instantiateViewController(withIdentifier: "RotationDiamondVC") as! RotationDiamondViewController)
        rotationVC.diamondLink = (diamond?.diamond360!)!
        self.navigationController?.pushViewController(rotationVC, animated: true)
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
            setupAlertCtrl()
            present(alertCtrl!, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: JewelryDiamondSpecCell? = tableView.dequeueReusableCell(withIdentifier: "DiamondSpecCell", for: indexPath) as? JewelryDiamondSpecCell
        if cell == nil {
            cell = JewelryDiamondSpecCell(style: .default, reuseIdentifier: "DiamondSpecCell")
        }
        switch indexPath.row {
        case 0:
            cell?.keyLabel.text = "Weight"
            cell?.valueLabel.text = diamond?.weight?.stringValue
            break
        case 1:
            cell?.keyLabel.text = "Color"
            cell?.valueLabel.text = diamond?.color
            break
        case 2:
            cell?.keyLabel.text = "Clarity"
            cell?.valueLabel.text = diamond?.clarity
            break
        case 3:
            cell?.keyLabel.text = "Measurements"
            cell?.valueLabel.text = diamond?.measurements
            break
        case 4:
            cell?.keyLabel.text = "Cut Grade"
            cell?.valueLabel.text = diamond?.cut_grade
            break
        case 5:
            cell?.keyLabel.text = "Lab"
            cell?.valueLabel.text = diamond?.lab
            break
        case 6:
            cell?.keyLabel.text = "Depth"
            cell?.valueLabel.text = diamond?.depth?.stringValue
            break
        default:
            cell?.keyLabel.text = "Depth"
            cell?.valueLabel.text = diamond?.depth?.stringValue
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }
    
 //***************  Pick and Uploading Photo  ******************
    
    func setupAlertCtrl() {
        alertCtrl = UIAlertController(title: "Select Diamond Image", message: nil, preferredStyle: .actionSheet)
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
    
    func showConfirmCtrl() {
        alertCtrl = UIAlertController(title: "Save Image?", message: nil, preferredStyle: .actionSheet)

        let save = UIAlertAction(title: "Save", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.uploadImage()
        })

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            // [self dismissViewControllerAnimated:YES completion:nil];
        })
        alertCtrl!.addAction(save)
        alertCtrl!.addAction(cancel)
        present(alertCtrl!, animated: true, completion: nil)
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
        diamondImageView.contentMode = .scaleAspectFill
        diamondImageView.image = photo
        
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
        self.shapeImageView.isHidden = true
        showConfirmCtrl()
        
    }
    
    func uploadImage(){
        
        var imageName = ""
        if diamond!.image == nil {
            imageName = diamond!.id!
        } else {
            imageName = diamond!.image!
        }
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = S3BucketName
        uploadRequest?.key = imageName + ".jpg"
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
            self.diamond?.image = S3BucketUrl + imageName + ".jpg"
            
            DiamondManager.sharedInstance.updateDiamondImageLink(diamond_id: self.diamond!.id!, link: self.diamond!.image!, completion: { (_ success: Bool) in
                if success {
                    self.shapeImageView.isHidden = true
                }
            })
            
            /*
            self.dynamoDbObjectMapper.save(self.diamond!, completionHandler: {(error: Error?) -> Void in
                if let error = error {
                    print(" Amazon DynamoDB Save Error: \(error)")
                    return
                }
 
                DispatchQueue.main.async(execute: {
                    self.shapeImageView.isHidden = true
                })
            })
 */

            return nil
        })
    }
    

 //**************************************************************

}
