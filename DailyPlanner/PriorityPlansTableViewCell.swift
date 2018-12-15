//
//  PriorityPlansTableViewCell.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/15/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class PriorityPlansTableViewCell: UITableViewCell {

    var resignationHandler: (() -> Void)?
    
    @IBOutlet weak var isCompletedLabel: UIButton!
    
    @IBAction func isCompletedButton(_ sender: UIButton) {
         resignationHandler?()
    }
    @IBOutlet weak var importantColorView: UIView!
    @IBOutlet weak var isCompletedImageView: UIImageView!
    @IBOutlet weak var planTitle: UILabel!
    
}
