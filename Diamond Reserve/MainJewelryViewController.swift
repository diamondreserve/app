//
//  MainJewelryViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/18/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class MainJewelryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var jewelryTypeButtons: [UIButton]!
    @IBOutlet var jewelryFeatureButtons: [UIButton]!
    var selectedTypeIndex: Int = 0
    var selectedFeatureIndex: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        didTypeButtonSelect(jewelryTypeButtons[selectedTypeIndex])
        didFeatureButtonPress(jewelryFeatureButtons[selectedFeatureIndex])
    }
    
    func setNavigationBar() {
        navigationItem.title = "JEWELRY"
        let menuBtn = UIBarButtonItem(image: UIImage(named:"MENU_ICON"), style: .plain, target: self, action: #selector(showSideMenu))
        navigationItem.leftBarButtonItem = menuBtn
        
        let rightBtn = UIBarButtonItem(title: "SELECT", style: .plain, target: self, action: #selector(showSelect))
        rightBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        rightBtn.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .highlighted)
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    func showSideMenu() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    func showSelect() {
        let diamondSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "DiamondSelectionVC") as! DiamondSelectionViewController
        self.navigationController?.pushViewController(diamondSelectionVC, animated: true)
    }
    
    @IBAction func didTypeButtonSelect(_ sender: UIButton) {
        let previousIndex = selectedTypeIndex
        selectedTypeIndex = sender.tag
        jewelryTypeButtons[previousIndex].isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func didFeatureButtonPress(_ sender: UIButton) {
        let previousIndex = selectedFeatureIndex
        selectedFeatureIndex = sender.tag
        jewelryFeatureButtons[previousIndex].isSelected = false
        sender.isSelected = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JewelryCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2
        let cellSize = CGSize(width: width, height: width + 10)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let jewelryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "JewelryDetailVC") as! JewelryDetailViewController
        self.navigationController?.pushViewController(jewelryDetailVC, animated: true)
    }
    
    



}
