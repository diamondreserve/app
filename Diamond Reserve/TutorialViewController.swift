//
//  TutorialViewController.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 28.09.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    
    
    @IBOutlet weak var frontImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
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
            self.logoImage.image = UIImage(named: "Diamond2")
            self.titleText.text = "SEARCH & ACCESS"
            self.frontImage.image = UIImage(named: "strip1.png")
            self.frontImage.alpha = 0.88
            self.mainText.text = "SEARCH THROUGH DIAMONDS, JEWELRY,\nAND ROUGH PRODUCTION, AND GET ALERTS\nON FINISHED STONES\n\nTO ACQUIRE FURTHER ACCESS TO INVENTORY,\nPRICING, AND PRODUCTION\nGO TO YOUR PROFILE ACCOUNT\nTO SEE IF YOU QUALIFY"
            self.nextButton.setTitle("NEXT", for: UIControlState.normal)
        }
        if(currentPage == 1){
            self.logoImage.image = UIImage(named: "Logout")
            self.titleText.text = "SHARE"
            self.frontImage.image = UIImage(named: "strip2.png")
            self.frontImage.alpha = 0.75
            self.mainText.text = "SHARING ANY DIAMONDS BY TAPPING\n THE SHARE ICON ABOVE\n\nTHIS WILL PROMPT YOU WITH OPTIONS\nTO SHARE DIAMOND IMAGES, GRADES, CERTIFICATES,\nVIDEOS, AND STATUS UPDATES"
            self.nextButton.setTitle("NEXT", for: UIControlState.normal)
        }
        else if (currentPage == 2) {
            self.logoImage.image = UIImage(named: "Plus")
            self.titleText.text = "RESERVE"
            self.frontImage.image = UIImage(named: "strip3.png")
            self.frontImage.alpha = 0.72
            self.mainText.text = "RESERVE ANY DIAMOND BY TAPPING THE\nRESERVE ICON ABOVE\n\nTHIS WILL PROMPT YOU WITH OPTIONS\n TO REQUEST A PARTICULAR DIAMOND\nBE RESERVED FOR YOU TO SHARE & PURCHASE"
            self.nextButton.setTitle("BEGIN", for: UIControlState.normal)
        }

    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if(scrollView.contentOffset.x == self.view.frame.size.width*2) {
            self.performSegue(withIdentifier: "showDiamondsVCSegue", sender: self)
        }
        else {
            scrollView.contentOffset.x += self.view.frame.size.width
            if(scrollView.contentOffset.x == self.view.frame.size.width*2) {
                self.nextButton.setTitle("BEGIN", for: UIControlState.normal)
            }
        
            else {
                self.nextButton.setTitle("NEXT", for: UIControlState.normal)
            }
        }
    }

}
