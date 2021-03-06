//
//  DiamondSearchViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/15/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import RangeSeekSlider
import MBProgressHUD

class DiamondSearchViewController: UIViewController {
    
    @IBOutlet var diamondButtons: [UIButton]!
    @IBOutlet weak var priceSlider: RangeSeekSlider!
    @IBOutlet weak var weightSlider: RangeSeekSlider!
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet var clarityButtons: [UIButton]!
    
    var selectedShapes = [String]()
    var selectedColors = [String]()
    var selectedClarities = [String]()
    
    var searchedDiamonds = [Diamonds]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
         self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        sideMenuController?.isLeftViewSwipeGestureDisabled = true
        weightSlider.minDistance = 0.2
    }

    func setNavigationBar() {
        let menuBtn = UIBarButtonItem(image: UIImage(named:"MENU_ICON"), style: .plain, target: self, action: #selector(showSideMenu))
        navigationItem.leftBarButtonItem = menuBtn
        
       
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("SEARCH", for: .normal)
        //Add target
        button.addTarget(self, action:#selector(DiamondSearchViewController.doneAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 28)
        button.titleLabel?.font = UIFont(name: "Unica One", size: 15)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        
        let rightBtn = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = rightBtn
        
        weightSlider.numberFormatter.numberStyle = .decimal
        weightSlider.numberFormatter.maximumFractionDigits = 2
        weightSlider.numberFormatter.maximumFractionDigits = 2

    }
    
    func showSideMenu() {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
    
    func cancelAction() {
        let tabbarVC:TabbarViewController = self.navigationController!.parent as! TabbarViewController
        tabbarVC.tabButtons[0].isSelected = true
        tabbarVC.didPressTab(tabbarVC.tabButtons[0])
    }
    
    func doneAction() {
        
        self.selectedShapes.removeAll()
        for button in diamondButtons {
            if button.isSelected {
                switch (button.tag){
                case 0:
                    selectedShapes.append("BR")
                    break
                case 1:
                    selectedShapes.append("PR")
                    break
                case 2:
                    selectedShapes.append("EM")
                    break
                case 3:
                    selectedShapes.append("AS")
                    break
                case 4:
                    selectedShapes.append("CU")
                    selectedShapes.append("CB")
                    break
                case 5:
                    selectedShapes.append("MO")
                    break
                case 6:
                    selectedShapes.append("RA")
                    selectedShapes.append("SB")
                    break
                case 7:
                    selectedShapes.append("OV")
                    break
                case 8:
                    selectedShapes.append("PS")
                    break
                default:
                    selectedShapes.append("HS")
                }
            }
        }
        if selectedShapes.count == 0 {
            selectedShapes = ["BR", "PR", "EM", "AS", "CU", "CB", "MO", "RA", "SB", "OV", "PS", "HS"]
        }
        
        self.selectedColors.removeAll()
        for button in colorButtons {
            if button.isSelected {
                switch (button.tag){
                case 0:
                    selectedColors.append("D")
                    break
                case 1:
                    selectedColors.append("E")
                    break
                case 2:
                    selectedColors.append("F")
                    break
                case 3:
                    selectedColors.append("G")
                    break
                case 4:
                    selectedColors.append("H")
                    break
                case 5:
                    selectedColors.append("I")
                    break
                case 6:
                    selectedColors.append("J")
                    break
                case 7:
                    selectedColors.append("K")
                    break
                case 8:
                    selectedColors.append("L")
                    break
                case 9:
                    selectedColors.append("M")
                    break
                case 10:
                    selectedColors.append("N")
                    break
                case 11:
                    selectedColors.append("O")
                    break
                case 12:
                    selectedColors.append("FIY")
                    break
                case 13:
                    selectedColors.append("FVY")
                    break
                case 14:
                    selectedColors.append("FY")
                    break
                case 15:
                    selectedColors.append("FLY")
                    break
                case 16:
                    selectedColors.append("FDBY")
                    break
                default:
                    selectedColors.append("Fancy Color")
                }
            }
        }
        if selectedColors.count == 0 {
            selectedColors = ["D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "FIY", "FVY", "FY", "FLY", "FDBY"]
        }
        
        self.selectedClarities.removeAll()
        for button in clarityButtons {
            if button.isSelected {
                switch (button.tag){
                case 0:
                    selectedClarities.append("FLAWLESS")
                    break
                case 1:
                    selectedClarities.append("IF")
                    break
                case 2:
                    selectedClarities.append("VVS1")
                    break
                case 3:
                    selectedClarities.append("VVS2")
                    break
                case 4:
                    selectedClarities.append("VS1")
                    break
                case 5:
                    selectedClarities.append("VS2")
                    break
                case 6:
                    selectedClarities.append("SI1")
                    break
                case 7:
                    selectedClarities.append("SI2")
                    break
                case 8:
                    selectedClarities.append("SI3")
                    break
                case 9:
                    selectedClarities.append("I1")
                    break
                case 10:
                    selectedClarities.append("I2")
                    break
                default:
                    selectedClarities.append("I3")
                }
            }
        }
        if selectedClarities.count == 0 {
            selectedClarities = ["FLAWLESS", "IF", "VVS1", "VVS2", "VS1", "VS2", "SI1", "SI2", "SI3", "I1", "I2", "I3"]
        }
        
        if DiamondManager.sharedInstance.allDiamonds != nil {
           filterAndMove()
        } else {
            MBProgressHUD.showAdded(to: view, animated: true)
            DiamondManager.sharedInstance.getAllDiamonds { (_ success: Bool, diamonds: [Diamonds]?) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if success {
                    DiamondManager.sharedInstance.allDiamonds = diamonds
                    self.filterAndMove()
                }
            }
        }

    }
    
    func filterAndMove(){
        searchedDiamonds = DiamondManager.sharedInstance.allDiamonds!.filter({selectedShapes.contains($0.shape!) &&
            selectedColors.contains($0.color ?? "") &&
            selectedClarities.contains($0.clarity ?? "") &&
            DiamondManager.sharedInstance.getMarkedUpPrice(origin:($0.price?.floatValue ?? 0)) >= Float(priceSlider.selectedMinValue) &&
            DiamondManager.sharedInstance.getMarkedUpPrice(origin:($0.price?.floatValue ?? 0)) < Float(priceSlider.selectedMaxValue) &&
            ($0.weight?.floatValue ?? 0) >= Float(weightSlider.selectedMinValue) &&
            ($0.weight?.floatValue ?? 0) < Float(weightSlider.selectedMaxValue)
        })
        
        DiamondManager.sharedInstance.filteredDiamonds = searchedDiamonds
        
        let tabbarVC:TabbarViewController = self.navigationController!.parent as! TabbarViewController
        let diamondNavVC = tabbarVC.viewControllers[0] as UINavigationController
        diamondNavVC.popToRootViewController(animated: false)
        
        let diamondSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "DiamondSelectionVC") as! DiamondSelectionViewController
        diamondNavVC.pushViewController(diamondSelectionVC, animated: true)
        
        tabbarVC.tabButtons[0].isSelected = true
        tabbarVC.didPressTab(tabbarVC.tabButtons[0])
    }
    
    @IBAction func didDiamondButtonSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func didColorButtonSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? UIColor.white : UIColor.clear
    }
    
    @IBAction func didClarityButtonSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? UIColor.white : UIColor.clear
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        doneAction()
    }
    
    
}
