//
//  MainDiamondsViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/11/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import AWSDynamoDB
import MBProgressHUD
import SwiftGifOrigin

class MainDiamondsViewController: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var diamondButtons: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIImageView!
    
    
    var lock:NSLock?
    var lastEvaluatedKey:[String : AWSDynamoDBAttributeValue]!
    var doneLoading = false
//    var tableRows:Array<DDBTableRow>?
    var diamonds = [Diamond]()
    
    var selectedShapes = ["BR", "PR", "EM", "AS", "CU", "CB", "MO", "RA", "SB", "OV", "PS", "HS"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        tableView.register(UINib(nibName: "DiamondTableViewCell", bundle: nil), forCellReuseIdentifier: "DiamondCell")
        //generateTestData()
        refreshList(false)
        loadingView.loadGif(name: "loading")
        
    }
    
    func setNavigationBar() {
        navigationItem.title = "DIAMONDS"
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
        if diamonds.count == 0 {
            return
        }
        let diamondSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "DiamondSelectionVC") as! DiamondSelectionViewController
        self.navigationController?.pushViewController(diamondSelectionVC, animated: true)
    }
    
    @IBAction func didDiamondButtonSelected(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
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
        
        if DiamondManager.sharedInstance.allDiamonds != nil {
            diamonds = DiamondManager.sharedInstance.allDiamonds!.filter({selectedShapes.contains($0.shape!)})
            DiamondManager.sharedInstance.filteredDiamonds = diamonds
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diamonds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: DiamondTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "DiamondCell", for: indexPath) as? DiamondTableViewCell
        if cell == nil {
            cell = DiamondTableViewCell(style: .default, reuseIdentifier: "DiamondCell")
        }
        cell?.setData(diamond: diamonds[indexPath.row]);
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor(red: 25, green: 25, blue: 25).withAlphaComponent(0.8) : UIColor(red: 38, green: 38, blue: 38).withAlphaComponent(0.8)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diamondDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "DiamondDetailVC") as! DiamondDetailViewController
        diamondDetailVC.diamond = diamonds[indexPath.row]
        self.navigationController?.pushViewController(diamondDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
//    func generateTestData() {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//
//         var tasks = [AWSTask<AnyObject>]()
//        let mapper = AWSDynamoDBObjectMapper.default()
//        var item: Diamonds = Diamonds()!;
//        item.diamondId = "1"
//        item.shape  = "round"
//        item.price   = "2032"
//        item.weight   = "2.52"
//        item.color = "D"
//        item.clarity = "VS2"
//        tasks.append(mapper.save(item))
//
//        item = Diamonds()!;
//        item.diamondId = "2"
//        item.shape  = "round"
//        item.price   = "2324"
//        item.weight   = "1.52"
//        item.color = "F"
//        item.clarity = "WS2"
//        tasks.append(mapper.save(item))
      
//        AWSTask<AnyObject>(forCompletionOfAllTasks: Optional(tasks)).continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask) -> AnyObject? in
//            if let error = task.error as? NSError {
//                print("Error: \(error)")
//            }
//
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//
//            self.refreshList(true)
//            return nil
//        })
//    }
    
    func refreshList(_ startFromBeginning: Bool)  {
        
        if DiamondManager.sharedInstance.allDiamonds != nil {
            self.diamonds = DiamondManager.sharedInstance.allDiamonds!
            self.tableView.reloadData()
            return
        }
 
        if startFromBeginning {
            self.lastEvaluatedKey = nil;
            self.doneLoading = false
        }
        
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBScanExpression()
        queryExpression.exclusiveStartKey = self.lastEvaluatedKey
        //queryExpression.limit = 20
        dynamoDBObjectMapper.scan(Diamond.self, expression: queryExpression).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            
            if self.lastEvaluatedKey == nil {
                self.diamonds.removeAll(keepingCapacity: true)
            }
            
            if let paginatedOutput = task.result {
                for item in paginatedOutput.items as! [Diamond] {
                    self.diamonds.append(item)
                }
                self.diamonds = self.diamonds.sorted(by: {($0.weight?.floatValue ?? 0) > ($1.weight?.floatValue ?? 0)})
                DiamondManager.sharedInstance.allDiamonds = self.diamonds
                DiamondManager.sharedInstance.filteredDiamonds = self.diamonds

                self.lastEvaluatedKey = paginatedOutput.lastEvaluatedKey
                if paginatedOutput.lastEvaluatedKey == nil {
                    self.doneLoading = true
                }
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.loadingView.isHidden = true
            //MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.reloadData()
            
            if let error = task.error as NSError? {
                print("Error: \(error)")
            }
            
            return nil
        })
        
    }
    

   

    

   
}
