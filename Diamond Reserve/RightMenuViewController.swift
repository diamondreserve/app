//
//  RightMenuViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/11/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import Firebase

class RightMenuViewController: UIViewController {
    
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomLabel.text = "CONTACT A DIAMOND RESERVE EXPERT AT: \nINFO@PREMIERGEM.COM"
        nameLabel.text = UserDefaults.standard.string(forKey: "fullname")
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
    
    @IBAction func logoutAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        moveToLogin()

        
    }
    
    func moveToLogin(){
        
        DiamondManager.sharedInstance.allDiamonds = nil
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let splashVC: SplashViewController = (storyboard.instantiateViewController(withIdentifier: "splashVC") as? SplashViewController)!
        let startNC: UINavigationController = storyboard.instantiateViewController(withIdentifier: "startNC") as! UINavigationController
        startNC.viewControllers = [splashVC]
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        window?.rootViewController = startNC
    }
    

}
