//
//  RightMenuViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/11/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController {
    
    @IBOutlet weak var bottomLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomLabel.text = "CONTACT A DIAMOND RESERVE EXPERT AT: \nSUPPORT@DIAMONDRESERVEAPP.COM"

    }

    @IBAction func contactButtonTapped(_ sender: Any) {
    }
    
    @IBAction func reserveButtonTapped(_ sender: Any) {
        let mainSideViewController : MainSideMenuController = self.sideMenuController as! MainSideMenuController
        mainSideViewController.hideLeftView(animated: true, completionHandler: nil)
        let tabbarVC:TabbarViewController = mainSideViewController.rootViewController as! TabbarViewController
        let diamondNavVC = tabbarVC.viewControllers[0] as UINavigationController
        let reserveListVC = self.storyboard?.instantiateViewController(withIdentifier: "ReserveListVC")
        diamondNavVC.pushViewController(reserveListVC!, animated: true)
        
        tabbarVC.tabButtons[0].isSelected = true
        tabbarVC.didPressTab(tabbarVC.tabButtons[0])
        //tabbarVC.present(reserveListVC!, animated: true, completion: nil)
    }
    
    @IBAction func messageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func wishlistButtonTapped(_ sender: Any) {
    }
    


}
