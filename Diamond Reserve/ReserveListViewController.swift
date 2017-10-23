//
//  ReserveListViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/23/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class ReserveListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pendingHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem(title: "BACK", style: .plain, target: self, action: #selector(backAction))
        backItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        navigationItem.leftBarButtonItem = backItem
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 //diamonds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            var cell: ReserveTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ReservedCell", for: indexPath) as? ReserveTableViewCell
            if cell == nil {
                cell = ReserveTableViewCell(style: .default, reuseIdentifier: "ReservedCell")
            }
            return cell!

        } else if (indexPath.section == 1){
            var cell: ReserveTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "PendingCell", for: indexPath) as? ReserveTableViewCell
            if cell == nil {
                cell = ReserveTableViewCell(style: .default, reuseIdentifier: "PendingCell")
            }
            return cell!
        } else {
            var cell: ReserveTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "RejectedCell", for: indexPath) as? ReserveTableViewCell
            if cell == nil {
                cell = ReserveTableViewCell(style: .default, reuseIdentifier: "RejectedCell")
            }
            return cell!
        }

        //cell?.setSelectable(isSelectable: true)
        //cell?.setData(diamond: diamonds[indexPath.row]);
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return pendingHeader
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 82
        } else {
            return 0
        }
    }

}
