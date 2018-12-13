//
//  PlansForSomeDayTableViewCell.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/9/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class PlansForSomeDayTableViewCell: UITableViewCell {
    
    var resignationHandler: (() -> Void)?
    
    @IBOutlet weak var isCompletedLabel: UIButton!
    
    @IBAction func isCompletedButton(_ sender: UIButton) {
       resignationHandler?()
    }
    
   
    @IBOutlet weak var isCompletedImage: UIImageView!
    
    @IBOutlet weak var planTitle: UILabel!
    
    @IBOutlet weak var importanColorView: UIView!
    
}
