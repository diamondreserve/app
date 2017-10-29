//
//  DiamondDetailViewController.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/19/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

enum ReserveState {
    case ready
    case pending
    case reserved
    case rejected
}

class DiamondDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var diamond : Diamond?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var diamondImageView: UIImageView!
    
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var purchaseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var rotateButtonHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var purchaseView: UIView!
    var reserveState : ReserveState = .ready
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print((diamond?.image ?? "empty image link"))
        
        if diamond?.image != nil {
            diamondImageView.sd_setImage(with: URL(string: (diamond?.image!)!), placeholderImage: UIImage(named: "diamond_detail_default"))
        } else {
            rotateButtonHeight.constant = 0
        }
        
        var shape = diamond?.shape
        if shape == "PR" {
            shape = "PRINCESS"
        } else if shape == "PS"{
            shape = "PEAR"
        } else if shape == "OV"{
            shape = "OVAL"
        } else if (shape == "CU" || shape == "CB"){
            shape = "CUSHION"
        } else if shape == "EM"{
            shape = "EMERALD"
        } else if shape == "HS"{
            shape = "HEART"
        } else if (shape == "RA" || shape == "SB"){
            shape = "RADIANT"
        } else if shape == "MO"{
            shape = "MARQUISE"
        } else if shape == "AS"{
            shape = "ASSCHER"
        } else if shape == "BR"{
            shape = "ROUND"
        }
        
        titleLabel.text = String.init(format: "%.2fct %@ %@, %@",(diamond?.weight?.floatValue ?? 0)!, (shape ?? ""), diamond?.color ?? "", diamond?.clarity ?? "")
        
        let price = (diamond?.price?.floatValue ?? 0) * (diamond?.weight?.floatValue ?? 0) * scale
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        priceLabel.text = (price == 0) ? "" : formatter.string(from: NSNumber(value: price))
        
        setNavigationBar()
        tableViewHeight.constant = 28 * 7
        purchaseViewHeight.constant = 0
        setUI()
    }
    
    func setNavigationBar() {
        navigationItem.title = "DIAMOND"
        
        let backItem = UIBarButtonItem(title: "BACK", style: .plain, target: self, action: #selector(backAction))
        backItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Unica One", size: 17)! ,NSForegroundColorAttributeName: UIColor.white], for: .normal)
        navigationItem.leftBarButtonItem = backItem
        
        
        let rightBtn = UIBarButtonItem(image: UIImage(named:"share"), style: .plain, target: self, action: #selector(shareAction))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    func setUI() {
        switch reserveState {
            case .ready:
                reserveButton.setTitle("RESERVE", for: .normal)
                purchaseViewHeight.constant = 0
                purchaseView.isHidden = true

                break
            case .pending:
                reserveButton.backgroundColor = UIColor(rgb : 0xb6b6b6)
                reserveButton.setTitle("PENDING", for: .normal)
                purchaseViewHeight.constant = 0
                purchaseView.isHidden = true

                break
            case .reserved:
                reserveButton.setTitle("RESERVED", for: .normal)
                reserveButton.backgroundColor = UIColor(rgb : 0x0FBB32)
                purchaseViewHeight.constant = 110
                purchaseView.isHidden = false

                break
            
            default:
                break
        }
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func shareAction() {
        
    }
    
    
    @IBAction func didPressReserverButton(_ sender: Any) {
        switch reserveState {
            case .ready:
                reserveState = .pending
                break
            case .pending:
                reserveState = .reserved
                break
            
            default:
                break
        }
        setUI()
    }
    
    @IBAction func showRotation360(_ sender: Any) {
        let rotationVC: RotationDiamondViewController = (storyboard?.instantiateViewController(withIdentifier: "RotationDiamondVC") as! RotationDiamondViewController)
        rotationVC.diamondLink = (diamond?.diamond360!)!
        self.navigationController?.pushViewController(rotationVC, animated: true)
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: JewelryDiamondSpecCell? = tableView.dequeueReusableCell(withIdentifier: "DiamondSpecCell", for: indexPath) as? JewelryDiamondSpecCell
        if cell == nil {
            cell = JewelryDiamondSpecCell(style: .default, reuseIdentifier: "DiamondSpecCell")
        }
        switch indexPath.row {
        case 0:
            cell?.keyLabel.text = "Weight"
            cell?.valueLabel.text = diamond?.weight?.stringValue
            break
        case 1:
            cell?.keyLabel.text = "Color"
            cell?.valueLabel.text = diamond?.color
            break
        case 2:
            cell?.keyLabel.text = "Clarity"
            cell?.valueLabel.text = diamond?.clarity
            break
        case 3:
            cell?.keyLabel.text = "Measurements"
            cell?.valueLabel.text = diamond?.measurements
            break
        case 4:
            cell?.keyLabel.text = "Cut Grade"
            cell?.valueLabel.text = diamond?.cut_grade
            break
        case 5:
            cell?.keyLabel.text = "Lab"
            cell?.valueLabel.text = diamond?.lab
            break
        case 6:
            cell?.keyLabel.text = "Depth"
            cell?.valueLabel.text = diamond?.depth?.stringValue
            break
        default:
            cell?.keyLabel.text = "Depth"
            cell?.valueLabel.text = diamond?.depth?.stringValue
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }

    

}
