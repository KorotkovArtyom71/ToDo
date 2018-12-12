//
//  WeekDaysFromTabBarViewController.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/5/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class WeekDaysFromTabBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var manager = DaysManager.shared
    var dateForSegue = Date()
    @IBOutlet weak var weekTableView: UITableView! {
        didSet {
            weekTableView.dataSource = self
            weekTableView.delegate = self
            weekTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    var dateArray = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date) - 1
        //        let weekday2 = calendar.component(.weekday, from: date.addingTimeInterval(86400))
        //        let weekday3 = calendar.component(.weekday, from: date.addingTimeInterval(86400 * 2))
        let day = NSCalendar.current.component(.day, from: Date())
        let month = NSCalendar.current.component(.month, from: Date())
        let weekdaysArray = [Weekday.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        print("\(weekday) WEEKDAY" )
        let todayDate = Date.today()
        if weekday > 1 {
            for i in 1...weekday-1 {
                dateArray.append( todayDate.addingTimeInterval(-86400.0*(Double(weekday)-Double(i))) )
            }
        }
        
        dateArray.append(Date.today())
       
        
        if weekday < 7 {
            for i in weekday+1...7 {
                dateArray.append( todayDate.addingTimeInterval(86400.0*(Double(i)-Double(weekday))) )
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Week Day Cell Identifier") as! WeekDayTableViewCell
        cell.dateLabel.text = dateArray[indexPath.row].stringForLayoutWeek()
        switch indexPath.row {
        case 0: cell.dayLabel.text = "MO"
        case 1: cell.dayLabel.text = "TU"
        case 2: cell.dayLabel.text = "WE"
        case 3: cell.dayLabel.text = "TH"
        case 4: cell.dayLabel.text = "FR"
        case 5: cell.dayLabel.text = "SA"
        case 6: cell.dayLabel.text = "SU"
        default: break
        }
        
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date) - 1
        if indexPath.row == weekday - 1 {
            cell.rootDayView.layer.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        cell.resignationHandler = { [weak self] in
            guard let self = self else { return }
            self.dateForSegue = self.dateArray[indexPath.row]
            
            self.performSegue(withIdentifier: "Adding New ToDo Segue", sender: cell)
        }
        
        let dayForCounting = DaysManager.shared.dayForDate(for: dateArray[indexPath.row])
        //print("\(dayForCounting.date)  \(dayForCounting.amountOfMadeToDos)  \(dayForCounting.amountOfToDos)")
        cell.numberOfMadeToDosLabel.text = "\(dayForCounting.amountOfMadeToDos)/\(dayForCounting.amountOfToDos)"
        if dayForCounting.amountOfToDos == 0 {
            cell.progressView.isHidden = true
            cell.numberOfMadeToDosLabel.text = "0 tasks"
        } else {
            cell.progressView.isHidden = false
        }
        if dayForCounting.amountOfToDos > 0, dayForCounting.amountOfMadeToDos == 0 {
            cell.progressView.progress = 0
        }
        return cell
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Adding New ToDo Segue" {
            if let cell = sender as? WeekDayTableViewCell {
                if let indexPath = weekTableView.indexPath(for: cell) {
                    if let vc = segue.destination.contents as? AddNewToDoViewController {
                        print(indexPath.row)
                        vc.date = self.dateForSegue
                    }
                }
            }
        } else {
            if segue.identifier == "Show Day Plans" {
                if let cell = sender as? WeekDayTableViewCell {
                    if let indexPath = weekTableView.indexPath(for: cell) {
                        if let vc = segue.destination.contents as? PlansForSomeDayViewController {
                            vc.day = DaysManager.shared.dayForDate(for: dateArray[indexPath.row])
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weekTableView.reloadData()
        print("new batch")
        for i in 0...6 {
            print(DaysManager.shared.dayForDate(for: dateArray[i]).dayPlans.count)
        }
    }
    
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}

extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTimePreservingSmallerComponents,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
   
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}

extension Date {
    func stringForLayoutWeek() -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let string = "\(day).\(month)"
        return string
    }
}

