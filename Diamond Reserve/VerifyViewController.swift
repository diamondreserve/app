//
//  VerifyViewController.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 28.09.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import AWSCore
import AWSDynamoDB
class VerifyViewController: BaseVC {
    @IBOutlet weak var verifyButton: UIButton!

    @IBOutlet weak var verifyEmailText: UITextField!
    @IBOutlet weak var statusText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyButton.layer.borderWidth = 1
        verifyButton.layer.borderColor = UIColor.white.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }

    @IBAction func verifyTapped(_ sender: Any) {
        if(verifyEmailText.text! == "" ){
            displayAlert(message: "Please fill all the fields in!")
            return
        }
        verifyButton.isEnabled = false
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        
        dynamoDbObjectMapper.load(Users.self, hashKey: verifyEmailText.text ?? "", rangeKey:nil).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
            if let error = task.error as NSError? {
                self.displayAlert(message: "Connection problem, please try later")
            } else if (task.result as? Users) != nil {
                DispatchQueue.main.async(execute: {
                    self.verifyButton.layer.borderColor = UIColor.init(red: 67/255.0, green: 196/255.0, blue: 47/255.0, alpha: 1).cgColor
                    self.statusText.textColor = UIColor.init(red: 67/255.0, green: 196/255.0, blue: 47/255.0, alpha: 1)
                    self.statusText.text = "BRILLIANT!\nYOUR ON THE LIST!"
                })
                
            }
            else if (task.result as? Users) == nil {
                DispatchQueue.main.async(execute: {
                    self.verifyButton.layer.borderColor = UIColor.init(red: 171/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1).cgColor
                    self.statusText.textColor = UIColor.init(red: 171/255.0, green: 47/255.0, blue: 47/255.0, alpha: 1)

                    self.statusText.text = "SORRY THIS EMAIL WAS NOT ON THE LIST\n TRY ANOTHER EMAIL?\n OR CONTACT SUPPORT@THEDIAMONDRESERVE.COM"
                })
            }
            self.verifyButton.isEnabled = true
            return nil
        })
        
    }
    
}
