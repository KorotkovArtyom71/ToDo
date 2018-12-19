//
//  PlansForSomeDayFromCalendarTableViewCell.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/19/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class PlansForSomeDayFromCalendarTableViewCell: UITableViewCell {

    var resignationHandler: (() -> Void)?
    @IBOutlet weak var planTitleLabel: UILabel!
    
    @IBOutlet weak var importanColorView: UIView!
    
    @IBAction func isCompletedButton(_ sender: UIButton) {
        resignationHandler?()
    }
    
    @IBOutlet weak var isCompletedLabel: UIButton!
    
    
    @IBOutlet weak var isCompletedImageView: UIImageView!
    
}
