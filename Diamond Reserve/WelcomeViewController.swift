//
//  WelcomeViewController.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 28.09.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var markups : [UIScrollView]!

    @IBOutlet weak var continueButton: UIButton!
    
    var selectedIndex: Int = 0
    
    var markupValues: [Float] = [1, 1, 1, 1, 1]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for scrollView: UIScrollView in markups {
            for i in 0..<20 {
                let label = UILabel(frame: CGRect(origin: CGPoint(x:0, y:40*i), size: CGSize(width: 49, height: 40)))
                label.text = String(format : "%d", i*10) + "%"
                label.textAlignment = .center
                label.textColor = .white
                scrollView.addSubview(label)
                scrollView.contentSize = CGSize(width:49, height:40*20)
            }
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tag = scrollView.tag
        let pageWidth: CGFloat = scrollView.frame.size.height;
        let fractionalPage = scrollView.contentOffset.y / pageWidth;
        let page = roundf(Float(fractionalPage));
        markupValues[tag] = 1 + 0.1 * page
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        DiamondManager.sharedInstance.markupValues = markupValues
        DiamondManager.sharedInstance.saveMarkupValues()
    }
    
    
}
