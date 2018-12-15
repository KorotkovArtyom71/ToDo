//
//  PriorityPlans.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/15/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import Foundation

class PriorityPlans: Codable {
    var dayPlans: [DailyPlan]
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(PriorityPlans.self, from: json) {
            self.dayPlans = newValue.dayPlans
        } else {
            return nil
        }
    }
    
    static var sharedPlans = PriorityPlans()
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var amountOfToDos: Int {
        return dayPlans.count
    }
    
    init() {
        dayPlans = [DailyPlan]()
    }
    
}
