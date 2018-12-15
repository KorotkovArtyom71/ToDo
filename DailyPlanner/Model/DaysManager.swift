//
//  DaysForAllTimeStorage.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/5/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import Foundation

class DaysManager: Codable
{
    
    var days: [WeekDay]
    func dayForDate(for date: Date) -> WeekDay {
        let calendar = NSCalendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        for index in days.indices {
            let comparingDay = calendar.component(.day, from: days[index].date)
            let comparingMonth = calendar.component(.month, from: days[index].date)
            if day == comparingDay, month == comparingMonth {
                return days[index]
            }
        }
        
        let weekDay = WeekDay()
        weekDay.date = date
        days.append(weekDay)
        return weekDay
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(DaysManager.self, from: json) {
            self.days = newValue.days
        } else {
            return nil
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static var shared = DaysManager()
    
    init() {
        self.days = [WeekDay]()
    }
    
}
