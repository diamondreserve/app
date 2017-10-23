//
//  DiamondDetailViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/19/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

enum ReserveState {
    case ready
    case pending
    case reserved
    case rejected
}

class DiamondDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var purchaseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reserveButton: UIButton!
    
    @IBOutlet weak var purchaseView: UIView!
    var reserveState : ReserveState = .ready
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "2.52ct Round D, VS2 Round"
        setNavigationBar()
        tableViewHeight.constant = 28 * 5
        purchaseViewHeight.constant = 0
        setUI()

    }
    
    func setNavigationBar() {
        navigationItem.title = "DIAMOND"
        
        let backItem = UIBarButtonItem(title: "BACK", style: .plain, target: self, action: #selector(backAction))
        backItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        navigationItem.leftBarButtonItem = backItem
        
        
        let rightBtn = UIBarButtonItem(image: UIImage(named:"share"), style: .plain, target: self, action: #selector(shareAction))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    func setUI() {
        switch reserveState {
            case .ready:
                reserveButton.setTitle("RESERVE", for: .normal)
                purchaseViewHeight.constant = 0
                purchaseView.isHidden = true

                break
            case .pending:
                reserveButton.backgroundColor = UIColor(rgb : 0xb6b6b6)
                reserveButton.setTitle("PENDING", for: .normal)
                purchaseViewHeight.constant = 0
                purchaseView.isHidden = true

                break
            case .reserved:
                reserveButton.setTitle("RESERVED", for: .normal)
                reserveButton.backgroundColor = UIColor(rgb : 0x0FBB32)
                purchaseViewHeight.constant = 110
                purchaseView.isHidden = false

                break
            
            default:
                break
        }
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func shareAction() {
        
    }
    
    
    @IBAction func didPressReserverButton(_ sender: Any) {
        switch reserveState {
            case .ready:
                reserveState = .pending
                
                break
            case .pending:
                reserveState = .reserved
                break
            
            default:
                break
        }
        setUI()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //diamonds.count
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
