//
//  SplashViewController.swift
//  Diamond Reserve
//
//  Created by CharlesFok on 26.09.17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor

        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.white.cgColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
