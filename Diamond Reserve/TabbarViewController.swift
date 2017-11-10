//
//  TabbarViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/14/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class TabbarViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var tabButtons: [UIButton]!
    
    var diamondNVC: UINavigationController!
    var jewelryNVC: UINavigationController!
    var messagesNVC: UINavigationController!
    var searchNVC: UINavigationController!
    
    var viewControllers: [UINavigationController]!
    var fromNotification : Bool = false
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        diamondNVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "MainDiamondsVC"))
        jewelryNVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "MainJewelryVC"))
        messagesNVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ReserveListVC"))
        searchNVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "DiamondSearchVC"))
        setAttributesFor(diamondNVC)
        setAttributesFor(jewelryNVC)
        setAttributesFor(messagesNVC)
        setAttributesFor(searchNVC)
        viewControllers = [diamondNVC, messagesNVC, searchNVC]
        
        tabButtons[selectedIndex].isSelected = true
        didPressTab(tabButtons[selectedIndex])
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification), name: NSNotification.Name("diamond_notification"), object: nil)
    }
    
    func receiveNotification(notification: Notification){
        
        DispatchQueue.main.async(execute: {
            
            self.messagesNVC.popToRootViewController(animated: false)
            
            let diamondDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DiamondDetailVC") as! DiamondDetailViewController
            let data = notification.object as! [String : Any]
            diamondDetailVC.diamond = data["object"] as! Diamonds
            diamondDetailVC.isFromDiamondList = false
            diamondDetailVC.isFromNotification = true
            self.messagesNVC.pushViewController(diamondDetailVC, animated: true)
            
            self.didPressTab(self.tabButtons[1])
        })
    }
   

    @IBAction func didPressTab(_ sender: UIButton) {
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        tabButtons[previousIndex].isSelected = false
        
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
        
        sender.isSelected = true
        let vc = viewControllers[selectedIndex]
        addChildViewController(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    func setAttributesFor(_ navController: UINavigationController) {
        navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navController.navigationBar.isHidden = false
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.barTintColor = DIAMOND_THEME_COLOR
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(20))
        navController.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Unica One", size: 24)!, NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-60, -60), for: UIBarMetrics.default)
    }

}
