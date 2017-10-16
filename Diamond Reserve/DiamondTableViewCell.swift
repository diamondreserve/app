//
//  DiamondTableViewCell.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/15/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import UIKit

class DiamondTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var shapeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var disclosureView: UIImageView!
    
    var isSelectable: Bool = false
    
    var diamond:Diamonds?

    override func awakeFromNib() {
        super.awakeFromNib()
        disclosureView.isHidden = isSelectable
        selectionButton.isHidden = !isSelectable
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSelectable(isSelectable: Bool){
        self.isSelectable = isSelectable
        disclosureView.isHidden = isSelectable
        selectionButton.isHidden = !isSelectable
    }
    
    func setData(diamond: Diamonds){
        self.diamond = diamond
        shapeLabel.text = diamond.shape

    }
    @IBAction func selectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
