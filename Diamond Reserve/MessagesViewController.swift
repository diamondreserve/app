//
//  DiamondSelectionViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/15/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        tableView.register(UINib(nibName: "DiamondTableViewCell", bundle: nil), forCellReuseIdentifier: "DiamondCell")
        DiamondManager.sharedInstance.selectedDiamonds = [Diamond]()
    }

    func setNavigationBar() {
        navigationItem.title = "MESSAGES"
        let menuBtn = UIBarButtonItem(image: UIImage(named:"MENU_ICON"), style: .plain, target: self, action: #selector(showSideMenu))
        navigationItem.leftBarButtonItem = menuBtn

    }
    
    func showSideMenu() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    func cancelAction() {
        navigationController?.popViewController(animated: true)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 //(DiamondManager.sharedInstance.allDiamonds?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: DiamondTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "DiamondCell", for: indexPath) as? DiamondTableViewCell
        if cell == nil {
            cell = DiamondTableViewCell(style: .default, reuseIdentifier: "DiamondCell")
        }
        //cell?.setSelectable(isSelectable: true)
        //cell?.setData(diamond: DiamondManager.sharedInstance.allDiamonds![indexPath.row]);
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
    
    @IBAction func nextAction(_ sender: Any) {
//        let diamondReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "DiamondReviewVC") as! DiamondReviewViewController
//        self.navigationController?.pushViewController(diamondReviewVC, animated: true)
    }
    

}
