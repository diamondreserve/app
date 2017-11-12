//
//  ReserveListViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/23/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import GIFRefreshControl

class ReserveListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pendingHeader: UIView!
    @IBOutlet weak var loadingView: UIImageView!
    @IBOutlet weak var noReserveLabel: UILabel!
    
    let refreshControl = GIFRefreshControl()
    
    var reservations: [Diamonds] = [Diamonds]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "RESERVE"
        let backItem = UIBarButtonItem(title: "BACK", style: .plain, target: self, action: #selector(backAction))
        backItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
 
        addRefreshControl()
        loadingView.loadGif(name: "loading")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    func addRefreshControl(){
        let url = Bundle.main.url(forResource: "loading_refresh", withExtension: "gif")
        do {
            let data = try Data(contentsOf: url!)
            refreshControl.animatedImage = GIFAnimatedImage(data: data)
            refreshControl.contentMode = .center
            refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
            tableView.addSubview(refreshControl)
        } catch {
        }
    }
    
    func pullToRefresh(){
        refreshList(pullToRefresh: true)
    }
    
    func refreshList(pullToRefresh: Bool = false)  {
        
        if (!pullToRefresh) {
            self.loadingView.isHidden = false
        }
        DiamondManager.sharedInstance.getAllReservations { (_ success: Bool, reservations: [Diamonds]?) in
            self.loadingView.isHidden = true
            if success {
                self.reservations = reservations!
                self.noReserveLabel.isHidden = (self.reservations.count > 0)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: ReserveTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ReserveCell", for: indexPath) as? ReserveTableViewCell
        if cell == nil {
            cell = ReserveTableViewCell(style: .default, reuseIdentifier: "ReservedCell")
        }
        cell?.setData(diamond: reservations[indexPath.row]);
        return cell!

    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let diamondDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DiamondDetailVC") as! DiamondDetailViewController
        diamondDetailVC.diamond = reservations[indexPath.row]
        diamondDetailVC.isFromDiamondList = false
        self.navigationController?.pushViewController(diamondDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    


}
