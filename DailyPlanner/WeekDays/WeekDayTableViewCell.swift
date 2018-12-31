//
//  WeekDayTableViewCell.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/6/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class WeekDayTableViewCell: UITableViewCell {

     var resignationHandler: (() -> Void)?
    
    @IBAction func addNewToDo(_ sender: UIButton) {
        resignationHandler?()
    }
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rootDayView: UIView!
    @IBOutlet weak var numberOfMadeToDosLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
}
