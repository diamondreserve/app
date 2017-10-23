//
//  JewelryDetailViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/18/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class JewelryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "10.00ct D, Flawless Pear Shape Diamond \nEngagement Ring in Platinum \n$450,000.00"
        setNavigationBar()
    }
    
    func setNavigationBar() {
        navigationItem.title = "JEWELRY"
        
        let backItem = UIBarButtonItem(title: "BACK", style: .plain, target: self, action: #selector(backAction))
        backItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        navigationItem.leftBarButtonItem = backItem
        
       
     let rightBtn = UIBarButtonItem(image: UIImage(named:"share"), style: .plain, target: self, action: #selector(shareAction))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func shareAction() {
        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //diamonds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: JewelryDiamondSpecCell? = tableView.dequeueReusableCell(withIdentifier: "DiamondSpecCell", for: indexPath) as? JewelryDiamondSpecCell
        if cell == nil {
            cell = JewelryDiamondSpecCell(style: .default, reuseIdentifier: "DiamondSpecCell")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }


}
