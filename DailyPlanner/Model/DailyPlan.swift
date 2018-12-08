//
//  DailyPlan.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/5/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class DailyPlan {
    var isCompleted: Bool
    var day: Date?
    var importantColor: UIColor
    var title: String
    
    init() {
        self.isCompleted = false
        self.day = Date()
        self.importantColor = .white
        self.title = ""
    }
    
    init?(isCompleted: Bool, day: Date?, importantColor: UIColor, title: String) {
        self.title = title
        self.isCompleted = isCompleted
        self.day = day
        self.importantColor = importantColor
    }
}
