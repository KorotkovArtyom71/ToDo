//
//  DailyPlan.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/5/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

struct Color : Codable {
    let red, green, blue, alpha : CGFloat
}

class DailyPlan: Codable
{
    private enum CodingKeys: String, CodingKey { case content, deadline, color, isCompleted }
    var isCompleted: Bool
    var day: Date?
    var importantColor: UIColor
    var title: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .content)
        day = try container.decode(Date.self, forKey: .deadline)
        let colorWrapper = try container.decode(Color.self, forKey: .color)
        importantColor = UIColor(red: colorWrapper.red, green: colorWrapper.green, blue: colorWrapper.blue, alpha: colorWrapper.alpha)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .content)
        try container.encode(day, forKey: .deadline)
        try container.encode(isCompleted, forKey: .isCompleted)
        var red : CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
        importantColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let colorWrapper = Color(red: red, green: green, blue: blue, alpha: alpha)
        try container.encode(colorWrapper, forKey: .color)
    }
    
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
