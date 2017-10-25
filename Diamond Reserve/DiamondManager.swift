//
//  DiamondManager.swift
//  Diamond Reserve
//
//  Created by PSIHPOK on 10/25/17.
//  Copyright © 2017 Slickster. All rights reserved.
//

import Foundation

class DiamondManager {
    
    static var sharedInstance = DiamondManager()
    
    var allDiamonds: [Diamond]?
    var filteredDiamonds: [Diamond] = [Diamond]()
    var selectedDiamonds: [Diamond] = [Diamond]()
    
    
}
