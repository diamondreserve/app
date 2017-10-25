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
    
    @IBOutlet weak var backgroundImageView1: UIImageView!
    @IBOutlet weak var backgroundImageView2: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let images: [UIImage] = [UIImage(named: "tutorial1")!, UIImage(named: "tutorial2")!, UIImage(named: "tutorial3")!]
    var currentPageNumber : Int = -1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self as UIScrollViewDelegate
        scrollView.contentSize = CGSize(width: self.view.frame.size.width * 3, height: self.view.frame.size.height)
        
        //initShow()
        let firstImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        firstImageView.image = images[0]
        firstImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(firstImageView)

        let secondImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        secondImageView.image = images[1]
        secondImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(secondImageView)

        let thirdImageView = UIImageView(frame: CGRect(x: SCREEN_WIDTH*2, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        thirdImageView.image = images[2]
        thirdImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(thirdImageView)
    }

/*

    func initShow(){
        let scrollNumber = max(0, min(images.count-1, (Int)(scrollView.contentOffset.x / SCREEN_WIDTH)))
        
        if scrollNumber != currentPageNumber {
            currentPageNumber = scrollNumber
            backgroundImageView1.image = images[currentPageNumber]
            backgroundImageView2.image = (currentPageNumber+1 != images.count) ? images[currentPageNumber+1] : nil
        }
        
        var offset = scrollView.contentOffset.x - ((CGFloat)(currentPageNumber) * SCREEN_WIDTH)
        
        if offset < 0 {
            setTitle(currentPage: 0)
            offset = SCREEN_WIDTH - min(-offset, SCREEN_WIDTH)
            backgroundImageView2.alpha = 0
            backgroundImageView1.alpha = (offset/SCREEN_WIDTH)
            
        } else if (offset != 0) {
            
            if scrollNumber == (images.count - 1) {
                setTitle(currentPage: images.count-1)
                backgroundImageView1.alpha = 1.0 - (offset/SCREEN_WIDTH)
            } else {
                setTitle(currentPage: (offset>SCREEN_WIDTH/2) ? currentPageNumber + 1 : currentPageNumber)
                backgroundImageView2.alpha = offset / SCREEN_WIDTH
                backgroundImageView1.alpha = 1.0 - backgroundImageView2.alpha
            }
            
        } else {
            setTitle(currentPage: currentPageNumber)
            backgroundImageView1.alpha = 1
            backgroundImageView2.alpha = 0
        }
        
    }
    
    func setTitle(currentPage : Int){
        
        if( currentPage == 0) {
            self.logoImage.image = UIImage(named: "Diamond2")
            self.titleText.text = "SEARCH & ACCESS"
            self.mainText.text = "SEARCH THROUGH DIAMONDS, JEWELRY,\nAND ROUGH PRODUCTION, AND GET ALERTS\nON FINISHED STONES\n\nTO ACQUIRE FURTHER ACCESS TO INVENTORY,\nPRICING, AND PRODUCTION\nGO TO YOUR PROFILE ACCOUNT\nTO SEE IF YOU QUALIFY"
            self.nextButton.setTitle("NEXT", for: UIControlState.normal)
        }
        if(currentPage == 1){
            self.logoImage.image = UIImage(named: "Logout")
            self.titleText.text = "SHARE"
            self.mainText.text = "SHARING ANY DIAMONDS BY TAPPING\n THE SHARE ICON ABOVE\n\nTHIS WILL PROMPT YOU WITH OPTIONS\nTO SHARE DIAMOND IMAGES, GRADES, CERTIFICATES,\nVIDEOS, AND STATUS UPDATES"
            self.nextButton.setTitle("NEXT", for: UIControlState.normal)
        }
        else if (currentPage == 2) {
            self.logoImage.image = UIImage(named: "Plus")
            self.titleText.text = "RESERVE"
            self.mainText.text = "RESERVE ANY DIAMOND BY TAPPING THE\nRESERVE ICON ABOVE\n\nTHIS WILL PROMPT YOU WITH OPTIONS\n TO REQUEST A PARTICULAR DIAMOND\nBE RESERVED FOR YOU TO SHARE & PURCHASE"
            self.nextButton.setTitle("BEGIN", for: UIControlState.normal)
        }
    }
 */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //initShow()

        let currentPage  = floor((scrollView.contentOffset.x - self.view.frame.size.width/2) / self.view.frame.size.width) + 1
        if( currentPage == 0) {
            self.logoImage.image = UIImage(named: "Diamond2")
            self.titleText.text = "SEARCH & ACCESS"
            self.mainText.text = "SEARCH THROUGH DIAMONDS, JEWELRY,\nAND ROUGH PRODUCTION, AND GET ALERTS\nON FINISHED STONES\n\nTO ACQUIRE FURTHER ACCESS TO INVENTORY,\nPRICING, AND PRODUCTION\nGO TO YOUR PROFILE ACCOUNT\nTO SEE IF YOU QUALIFY"
            self.nextButton.setTitle("NEXT", for: UIControlState.normal)
        }
        if(currentPage == 1){
            self.logoImage.image = UIImage(named: "Logout")
            self.titleText.text = "SHARE"
            self.mainText.text = "SHARING ANY DIAMONDS BY TAPPING\n THE SHARE ICON ABOVE\n\nTHIS WILL PROMPT YOU WITH OPTIONS\nTO SHARE DIAMOND IMAGES, GRADES, CERTIFICATES,\nVIDEOS, AND STATUS UPDATES"
            self.nextButton.setTitle("NEXT", for: UIControlState.normal)
        }
        else if (currentPage == 2) {
            self.logoImage.image = UIImage(named: "Plus")
            self.titleText.text = "RESERVE"
            self.mainText.text = "RESERVE ANY DIAMOND BY TAPPING THE\nRESERVE ICON ABOVE\n\nTHIS WILL PROMPT YOU WITH OPTIONS\n TO REQUEST A PARTICULAR DIAMOND\nBE RESERVED FOR YOU TO SHARE & PURCHASE"
            self.nextButton.setTitle("BEGIN", for: UIControlState.normal)
        }


    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        initShow()
//    }
 
    @IBAction func nextButtonTapped(_ sender: Any) {
        if(scrollView.contentOffset.x == self.view.frame.size.width*2) {
            self.performSegue(withIdentifier: "showDiamondsVCSegue", sender: self)
        }
        else {
            let left = self.scrollView.contentOffset.x
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset.x = left + SCREEN_WIDTH
                if(self.scrollView.contentOffset.x == self.view.frame.size.width*2) {
                    self.nextButton.setTitle("BEGIN", for: UIControlState.normal)
                } else {
                    self.nextButton.setTitle("NEXT", for: UIControlState.normal)
                }
            }, completion: nil)
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if(scrollView.contentOffset.x == 0) {
            navigationController?.popViewController(animated: true)
        }
        else {
            let left = self.scrollView.contentOffset.x
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset.x = left - SCREEN_WIDTH
                if(self.scrollView.contentOffset.x == self.view.frame.size.width*2) {
                    self.nextButton.setTitle("BEGIN", for: UIControlState.normal)
                } else {
                    self.nextButton.setTitle("NEXT", for: UIControlState.normal)
                }
            }, completion: nil)
        }
    }
    
}
