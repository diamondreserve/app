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
    var productionNVC: UINavigationController!
    var searchNVC: UINavigationController!
    
    var viewControllers: [UINavigationController]!
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        diamondNVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "MainDiamondsVC"))
        jewelryNVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "MainJewelryVC"))
        productionNVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "MainDiamondsVC"))
        searchNVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "DiamondSearchVC"))
        setAttributesFor(diamondNVC)
        setAttributesFor(jewelryNVC)
        setAttributesFor(productionNVC)
        setAttributesFor(searchNVC)
        viewControllers = [diamondNVC, jewelryNVC, productionNVC, searchNVC]
        
        tabButtons[selectedIndex].isSelected = true
        didPressTab(tabButtons[selectedIndex])
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
