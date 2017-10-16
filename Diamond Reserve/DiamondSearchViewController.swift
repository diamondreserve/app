//
//  DiamondSearchViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/15/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import RangeSeekSlider

class DiamondSearchViewController: UIViewController {
    
    @IBOutlet var diamondButtons: [UIButton]!
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet var clarityButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
    }

    func setNavigationBar() {
        navigationItem.title = "SEARCH"
        let menuBtn = UIBarButtonItem(image: UIImage(named:"MENU_ICON"), style: .plain, target: self, action: #selector(showSideMenu))
        navigationItem.leftBarButtonItem = menuBtn
        
        let rightBtn = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancelAction))
        rightBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        rightBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .highlighted)

        navigationItem.rightBarButtonItem = rightBtn
        
//        priceSlider.numberFormatter = NSNumberFormatterCurrencyStyle
    }
    
    func showSideMenu() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    func cancelAction() {

        
    }
    
    @IBAction func didDiamondButtonSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func didColorButtonSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? UIColor.white : UIColor.clear
    }
    
    @IBAction func didClarityButtonSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? UIColor.white : UIColor.clear
    }
    
    
    
}
