//
//  DiamondsViewController.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 05.10.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class CoverPageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var backgroundImageView1: UIImageView!
    @IBOutlet weak var backgroundImageView2: UIImageView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var gifView: UIImageView!
    
    let images: [UIImage] = [UIImage(named: "cover_full1")!, UIImage(named: "cover_full2")!, UIImage(named: "cover_full3")!]
    
    
    var currentPageNumber : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self as UIScrollViewDelegate
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 3, height: SCREEN_HEIGHT)
        initShow()
        gifView.loadGif(name: "loading2")
        
    }
    
    func initShow(){
        
        if scrollView.contentOffset.x > 2 * SCREEN_WIDTH + 10 {
            currentPageNumber = 0
            nextButtonTapped(0)
            return
        }
        
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


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        initShow()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        initShow()
    }
    
    func setTitle(currentPage : Int){
        
        if( currentPage == 0) {
            self.titleText.text = "DIAMONDS"
            self.mainText.text = "TAP \"DIAMONDS\" AND PULL TO REFRESH PERIODICALLY TO BROWSE THE DIAMONDS IN REAL TIME"
        }
        if(currentPage == 1){
            self.titleText.text = "RESERVE"
            self.mainText.text = "TAP \"RESERVE\" TO HOLD A DIAMOND FOR 24 HOURS AS YOUR VERY OWN"
        }
        else if (currentPage == 2) {
            self.titleText.text = "SEARCH"
            self.mainText.text = "TAP \"SEARCH\" TO FILTER SPECIFIC DIAMONDS AND RARE DIAMOND JEWELRY"
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        self.loadingView.isHidden = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC: HomeViewController? = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController
        
        DiamondManager.sharedInstance.getAllDiamonds { (_ success: Bool, diamonds: [Diamonds]?) in
            self.loadingView.isHidden = true
            if success {
                DiamondManager.sharedInstance.allDiamonds = diamonds
                DiamondManager.sharedInstance.filteredDiamonds = diamonds!
            }
            self.present(homeVC!, animated: true, completion: nil)
        }
        
/*
        UserManager.sharedInstance.getHomeText { (_ success: Bool, title: String?) in
            self.loadingView.isHidden = false
            if success {
                homeVC?.home_title = title
            }
            self.present(homeVC!, animated: true, completion: nil)
        }
 */
        

    }
    
}
