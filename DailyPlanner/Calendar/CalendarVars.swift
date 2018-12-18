//
//  CalendarVars.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/18/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

var day = calendar.component(.day, from: date)
var weekday = calendar.component(.weekday, from: date) - 1
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)
