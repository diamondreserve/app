//
//  ReserveTableViewCell.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/23/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class ReserveTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var diamond:Diamonds?
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var colorBackgroundView: UIView!
    @IBOutlet weak var shapeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var timeIconView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    func setData(diamond: Diamonds){
        self.diamond = diamond
        var shape = diamond.shape
        var defaultImage = UIImage(named: "round_normal")
        if shape == "PR" {
            shape = "PRINCESS"
            defaultImage = UIImage(named: "princess_normal")
        } else if shape == "PS"{
            shape = "PEAR"
            defaultImage = UIImage(named: "pear_normal")
        } else if shape == "OV"{
            shape = "OVAL"
            defaultImage = UIImage(named: "oval_normal")
        } else if (shape == "CU" || shape == "CB"){
            shape = "CUSHION"
            defaultImage = UIImage(named: "cushion_normal")
        } else if shape == "EM"{
            shape = "EMERALD"
            defaultImage = UIImage(named: "emerald_normal")
        } else if shape == "HS"{
            shape = "HEART"
            defaultImage = UIImage(named: "heart_normal")
        } else if (shape == "RA" || shape == "SB"){
            shape = "RADIANT"
            defaultImage = UIImage(named: "radiant_normal")
        } else if shape == "MO"{
            shape = "MARQUISE"
            defaultImage = UIImage(named: "marquise_normal")
        } else if shape == "AS"{
            shape = "ASSCHER"
            defaultImage = UIImage(named: "asscher_normal")
        } else if shape == "BR"{
            shape = "ROUND"
            defaultImage = UIImage(named: "round_normal")
        }
        shapeLabel.text = shape
        let price = DiamondManager.sharedInstance.getMarkedUpPrice(origin: diamond.price?.floatValue ?? 0) * (diamond.weight?.floatValue ?? 0)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        priceLabel.text = (price == 0) ? "N/A" : formatter.string(from: NSNumber(value: price))
        weightLabel.text = (diamond.weight?.stringValue ?? "") + "ct"
        colorLabel.text = (diamond.color ?? "") + "," + (diamond.clarity ?? "")
//        if diamond.image != nil && diamond.image! != "" {
//            iconView.image = nil
//            iconView.sd_setImage(with: URL(string: diamond.image!), placeholderImage: defaultImage)
//            iconView.contentMode = .scaleAspectFill
//        } else {
//            iconView.image = nil
//            iconView.image = defaultImage
//            iconView.contentMode = .scaleAspectFit
//        }
        
        switch diamond.status! {
        case "rejected":
            colorBackgroundView.backgroundColor = UIColor(rgb: 0x6E2424).withAlphaComponent(0.54)
            timerLabel.textColor = UIColor(rgb: 0x6E2424)
            timerLabel.text = "REJECTED"
            timeIconView.image = UIImage(named: "red_clock")
            break
        case "pending":
            colorBackgroundView.backgroundColor = UIColor(rgb: 0x616161).withAlphaComponent(0.54)
            timerLabel.textColor = UIColor(rgb: 0x616161)
            timeIconView.image = UIImage(named: "white_clock")
            timerLabel.text = "PENDING"
            break
        default:
            colorBackgroundView.backgroundColor = UIColor(rgb: 0x3EA658).withAlphaComponent(0.54)
            timerLabel.textColor = UIColor(rgb: 0x3EA658)
            timeIconView.image = UIImage(named: "green_clock")
            timerLabel.text = "RESERVED"
        }
    }



}
