//
//  RotationDiamondViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/26/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import MBProgressHUD

class RotationDiamondViewController: UIViewController, UIWebViewDelegate {
    
    var diamondLink: String = "https://www.apple.com"

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        MBProgressHUD .showAdded(to: view, animated: true)
        webView.loadRequest(URLRequest(url: URL(string: diamondLink)!))
        setNavigationBar()

    }
    
    func setNavigationBar() {
        navigationItem.title = "360 Degree"
        
        let backItem = UIBarButtonItem(title: "BACK", style: .plain, target: self, action: #selector(backAction))
        backItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        navigationItem.leftBarButtonItem = backItem
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: webview delegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }



}
