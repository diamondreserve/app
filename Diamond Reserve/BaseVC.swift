//
//  BaseVC.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 08.10.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseVC: UIViewController, NVActivityIndicatorViewable{
    var activityIndicatorView: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let x = self.view.frame.size.width/2 - 50
        let y = self.view.frame.size.height/2 - 50
        let frame = CGRect(x: x, y: y, width: 100, height: 100)
        self.activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType(rawValue: 0)!)

        self.view.addSubview(activityIndicatorView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(message: String) {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    func showIndicator() {
        activityIndicatorView.startAnimating()
    }
    
    func hideIndicator() {
        activityIndicatorView.stopAnimating()
    }

}
