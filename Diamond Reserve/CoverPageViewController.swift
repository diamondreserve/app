//
//  DiamondsViewController.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 05.10.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class CoverPageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var backgroundImageView1: UIImageView!
    @IBOutlet weak var backgroundImageView2: UIImageView!
    
    
    let images: [UIImage] = [UIImage(named: "Emerald.png")!, UIImage(named: "Emerald2.png")!, UIImage(named: "Emerald3.png")!]
    
    
    var currentPageNumber : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self as UIScrollViewDelegate
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 3, height: SCREEN_HEIGHT)
        initShow()
    }
    
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


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        initShow()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        initShow()
    }
    
    func setTitle(currentPage : Int){
        
        if( currentPage == 0) {
            self.titleText.text = "DIAMONDS"
            self.mainText.text = "SEARCH FOR THE MOST EXQUISITE\nDIAMONDS YOU WONT FIND ON RAPPNET"
        }
        if(currentPage == 1){
            self.titleText.text = "JEWELRY"
            self.mainText.text = "DISCOVER & RESERVE ONE-OF-A-KIND\nDIAMOND JEWELRY"
        }
        else if (currentPage == 2) {
            self.titleText.text = "PRODUCTION"
            self.mainText.text = "FOLLOW EXCEPTIONAL DIAMONDS BEFORE\nTHEY HIT THE MARKET"
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabbarVC: TabbarViewController? = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as? TabbarViewController
        mainTabbarVC?.selectedIndex = currentPageNumber
        
        let mainViewController: MainSideMenuController = (storyboard.instantiateViewController(withIdentifier: "MainSideMenuVC") as? MainSideMenuController)!
        mainViewController.rootViewController = mainTabbarVC
        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        window?.rootViewController = mainViewController
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: { _ in })

    }
    


}
