//
//  WelcomeViewController.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 28.09.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet var buttons : [UIButton]!

    @IBOutlet weak var continueButton: UIButton!
    
    var selectedIndex: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        percentButtonTapped(buttons[selectedIndex])
    }

    @IBAction func percentButtonTapped(_ sender: UIButton) {
        
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        buttons[previousIndex].backgroundColor = UIColor.clear
        sender.backgroundColor = UIColor(rgb: 0x018662)
        
        switch sender.tag {
            case 0:
                scale = 2
                break
            case 1:
                scale = 2.5
                break
            default:
                scale = 3
        }
        
    }
    
    
}
