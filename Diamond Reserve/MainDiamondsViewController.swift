//
//  MainDiamondsViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/11/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class MainDiamondsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    func setNavigationBar() {
        navigationItem.title = "DIAMONDS"
        let menuBtn = UIBarButtonItem(image: UIImage(named:"MENU_ICON"), style: .plain, target: self, action: #selector(showSideMenu))
        navigationItem.leftBarButtonItem = menuBtn
       
        let rightBtn = UIBarButtonItem(title: "SELECT", style: .plain, target: self, action: #selector(showSelect))
        rightBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    func showSideMenu() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    func showSelect() {
        
    }
    
    

   
}
