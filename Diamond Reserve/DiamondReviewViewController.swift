//
//  DiamondReviewViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/15/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class DiamondReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var returnMainButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var hangTightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        submitButton.layer.borderColor = UIColor.white.cgColor
        submitButton.layer.borderWidth = 1
        submitButton.backgroundColor = UIColor(rgb : 0x0E122E)
        
        tableView.register(UINib(nibName: "DiamondTableViewCell", bundle: nil), forCellReuseIdentifier: "DiamondCell")
        
        returnMainButton.isHidden = true
        successView.isHidden = true
        hangTightLabel.text = "HANG TIGHT \nYOU WILL BE NOTIFIED SHORTLY"

    }
    
    func setNavigationBar() {
        navigationItem.title = "REVIEW"
        
        let backItem = UIBarButtonItem(title: "BACK", style: .plain, target: self, action: #selector(backAction))
        backItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        navigationItem.leftBarButtonItem = backItem
        
//        let menuBtn = UIBarButtonItem(image: UIImage(named:"MENU_ICON"), style: .plain, target: self, action: #selector(backAction))
//        navigationItem.backBarButtonItem = menuBtn
        
        let rightBtn = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancelAction))
        rightBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        rightBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .highlighted)

        navigationItem.rightBarButtonItem = rightBtn
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func cancelAction() {
        navigationController?.popViewController(animated: true)
    }
 
    @IBAction func submitAction(_ sender: Any) {
        returnMainButton.isHidden = false
        submitButton.isHidden = true
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.title = ""
        successView.isHidden = false
    }
    
    @IBAction func returnMainAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DiamondManager.sharedInstance.selectedDiamonds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: DiamondTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "DiamondCell", for: indexPath) as? DiamondTableViewCell
        if cell == nil {
            cell = DiamondTableViewCell(style: .default, reuseIdentifier: "DiamondCell")
        }
        cell?.disclosureView.isHidden = true
        cell?.setData(diamond: DiamondManager.sharedInstance.selectedDiamonds[indexPath.row]);
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor(red: 25, green: 25, blue: 25).withAlphaComponent(0.8) : UIColor(red: 38, green: 38, blue: 38).withAlphaComponent(0.8)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
