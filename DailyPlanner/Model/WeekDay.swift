//
//  WeekDay.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/5/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class WeekDay : Codable {
    var date = Date()
    var dayPlans = [DailyPlan]()
    
    var amountOfToDos: Int {
        return dayPlans.count
    }
    
    var amountOfMadeToDos: Int {
        var amount = 0
        for index in dayPlans.indices {
            if dayPlans[index].isCompleted {
                amount += 1
            }
        }
        return amount
    }
}
