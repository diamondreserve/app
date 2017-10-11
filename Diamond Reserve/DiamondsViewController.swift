//
//  DiamondsViewController.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 05.10.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class DiamondsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var frontImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self as UIScrollViewDelegate
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * 3, height: self.view.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage  = floor((scrollView.contentOffset.x - self.view.frame.size.width/2) / self.view.frame.size.width) + 1
        if( currentPage == 0) {
            
            self.titleText.text = "DIAMONDS"
            self.frontImage.image = UIImage(named: "Emerald.png")
            self.frontImage.alpha = 0.88
            self.mainText.text = "SEARCH FOR THE MOST EXQUISITE\nDIAMONDS YOU WONT FIND ON RAPPNET"
            
        }
        if(currentPage == 1){
            
            self.titleText.text = "JEWELRY"
            self.frontImage.image = UIImage(named: "Emerald2.png")
            self.frontImage.alpha = 0.75
            self.mainText.text = "DISCOVER & RESERVE ONE-OF-A-KIND\nDIAMOND JEWELRY"
            
        }
        else if (currentPage == 2) {
            
            self.titleText.text = "PRODUCTION"
            self.frontImage.image = UIImage(named: "Emerald3.png")
            self.frontImage.alpha = 0.72
            self.mainText.text = "FOLLOW EXCEPTIONAL DIAMONDS BEFORE\nTHEY HIT THE MARKET"
            
        }
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if(scrollView.contentOffset.x == self.view.frame.size.width*2) {
            self.performSegue(withIdentifier: "showDiamondsListView", sender: self)
        }
        else {
            scrollView.contentOffset.x += self.view.frame.size.width
        }
    }

}
