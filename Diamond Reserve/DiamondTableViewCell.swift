//
//  DiamondTableViewCell.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/15/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit
import SDWebImage


class DiamondTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var shapeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var disclosureView: UIImageView!
    
    var diamond:Diamond?

    override func awakeFromNib() {
        super.awakeFromNib()

        iconView.layer.cornerRadius = iconView.bounds.width / 2.0
        iconView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSelectable(isSelectable: Bool){
        disclosureView.isHidden = isSelectable
        selectionButton.isHidden = !isSelectable
        selectionButton.isSelected = false
    }
    
    func setData(diamond: Diamond){
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
        priceLabel.text = diamond.price?.stringValue
        weightLabel.text = diamond.weight?.stringValue
        colorLabel.text = (diamond.color ?? "") + "," + (diamond.clarity ?? "")
        if diamond.image != nil {
            iconView.image = nil
            iconView.sd_setImage(with: URL(string: diamond.image!), placeholderImage: defaultImage)
            iconView.layer.borderColor = UIColor.white.cgColor
            iconView.layer.borderWidth = 1.8
            iconView.transform = CGAffineTransform(scaleX: 1, y: 1)
            iconView.contentMode = .scaleAspectFill
        } else {
            iconView.image = nil
            iconView.image = defaultImage
            iconView.layer.borderWidth = 0
            iconView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            iconView.contentMode = .scaleAspectFit

        }

    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            DiamondManager.sharedInstance.selectedDiamonds.append(self.diamond!)
        } else {
            if let index = DiamondManager.sharedInstance.selectedDiamonds.index(of:self.diamond!) {
                DiamondManager.sharedInstance.selectedDiamonds.remove(at: index)
            }
        }
    }
    
}
