//
//  PlansForSomeDayViewController.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/9/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class PlansForSomeDayFromCalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var day = WeekDay()
    
    @IBOutlet weak var plansTableView: UITableView! {
        didSet {
            plansTableView.dataSource = self
            plansTableView.delegate = self
            plansTableView.separatorStyle = .none
            self.title = "ToDo"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return day.amountOfToDos
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = plansTableView.dequeueReusableCell(withIdentifier: "ToDo For Some Day From Calendar Identifier") as! PlansForSomeDayFromCalendarTableViewCell
        cell.importanColorView.layer.cornerRadius = 25
        cell.importanColorView.backgroundColor = day.dayPlans[indexPath.row].importantColor
        cell.planTitleLabel.text = day.dayPlans[indexPath.row].title
        cell.isCompletedLabel.layer.borderWidth = 1
        cell.isCompletedLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        if cell.importanColorView.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
            cell.importanColorView.layer.borderWidth = 1
            cell.importanColorView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        switch day.dayPlans[indexPath.row].isCompleted {
        case true: cell.isCompletedImageView.image = UIImage.init(named: "check_button_icon")
        case false: cell.isCompletedImageView.image = UIImage()
        default: break
        }
        cell.resignationHandler = { [weak self] in
            guard let self = self else { return }
            self.day.dayPlans[indexPath.row].isCompleted = !self.day.dayPlans[indexPath.row].isCompleted
            if let json = DaysManager.shared.json {
                if let url = try? FileManager.default.url(
                    for: .documentDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                    ).appendingPathComponent("Untitled.json") {
                    do {
                        try json.write(to: url)
                        print("saved succefully!")
                    } catch let error {
                        print("couldn't save\(error)")
                    }
                }
                
            }
            self.plansTableView.reloadData()
        }
        return cell
    }
    
}
