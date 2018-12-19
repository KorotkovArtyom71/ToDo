//
//  CalendarFromTabBarViewController.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/5/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class CalendarFromTabBarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBAction func nextButton(_ sender: UIButton) {
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            direction = 1
            
            if leapYearCounter < 5 {
                leapYearCounter += 1
            }
            
            if leapYearCounter == 4 {
                dayInMonths[1] = 29
            }
            
            if leapYearCounter == 5 {
                dayInMonths[1] = 28
                leapYearCounter = 1
            }
            
            getStartDateDayPosition()
            currentMonth = months[month] 
            monthLabel.text = "\(currentMonth) \(year)"
            calendarCollectionView.reloadData()
        default:
            direction = 1
            getStartDateDayPosition()
            month += 1
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarCollectionView.reloadData()
        }
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            direction = -1
            if leapYearCounter > 0 {
                leapYearCounter -= 1
            }
            if leapYearCounter != 0  {
                dayInMonths[1] = 28
            }
            if leapYearCounter == 0 {
                dayInMonths[1] = 29
                leapYearCounter = 4
            }
            getStartDateDayPosition()
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarCollectionView.reloadData()
        default:
            month -= 1
            currentMonth = months[month]
            direction = -1
            getStartDateDayPosition()
            monthLabel.text = "\(currentMonth) \(year)"
            calendarCollectionView.reloadData()
        }
    }
    
    func getStartDateDayPosition() {
        switch direction {
        case 0:
            numberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0 {
                numberOfEmptyBox = numberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBox == 0 {
                    numberOfEmptyBox = 7
                }
            }
            if numberOfEmptyBox == 7 {
                numberOfEmptyBox = 0
            }
            positionIndex = numberOfEmptyBox
        case 1...:
            nextNumberOfEmprtyBox = (positionIndex + dayInMonths[month]) % 7
            positionIndex = nextNumberOfEmprtyBox
        case -1:
            previousNumberOfEmptyBox = (7 - (dayInMonths[month] - positionIndex) % 7)
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    
    @IBOutlet weak var calendarCollectionView: UICollectionView! {
        didSet {
            calendarCollectionView.dataSource = self
            calendarCollectionView.delegate = self
        }
    }
    
    let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    let dayOfMonths = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    var dayInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    var numberOfEmptyBox = Int()
    var currentMonth = String()
    var nextNumberOfEmprtyBox = Int()
    var previousNumberOfEmptyBox = 0
    var direction = 0
    var positionIndex = 0
    var leapYearCounter = 2
    var dayCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMonth = months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 7
        }
        getStartDateDayPosition()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction {
        case 0:
            return dayInMonths[month] + numberOfEmptyBox
        case 1...:
            return dayInMonths[month] + nextNumberOfEmprtyBox
        case -1:
            return dayInMonths[month] + previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "Calendar Day Collection View Cell Identifier", for: indexPath) as! DateCollectionViewCell
        
        cell.isHidden = false
        
        cell.dateLabel.textColor = UIColor.black
        
        cell.backgroundColor = UIColor.clear
        
        switch direction {
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmprtyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.dateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        switch  indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:
            cell.dateLabel.textColor = UIColor.red
        default:
            break
        }
        
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Plans For Some Day From Calnedar Segue" {
            if let cell = sender as? DateCollectionViewCell {
                if let indexPath = calendarCollectionView.indexPath(for: cell) {
                    if Int(cell.dateLabel.text!)! >= 1, let vc = segue.destination.contents as? PlansForSomeDayFromCalendarViewController {
                        print(indexPath.row)
                        let dateForCounting = calendar.date(from: DateComponents(year: year, month: month + 1, day: Int(cell.dateLabel.text!)!))
                        let dayForCounting = DaysManager.shared.dayForDate(for: dateForCounting!)
                        vc.day = dayForCounting
                    }
                }
            }
        }
    }
    
}
