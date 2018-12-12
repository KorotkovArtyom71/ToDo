//
//  PlansForSomeDayViewController.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/9/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class PlansForSomeDayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var day = WeekDay()
    
    @IBOutlet weak var plansTableView: UITableView! {
        didSet {
            plansTableView.dataSource = self
            plansTableView.delegate = self
            plansTableView.separatorStyle = .none
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
        let cell = plansTableView.dequeueReusableCell(withIdentifier: "ToDo For Some Day Identifier") as! PlansForSomeDayTableViewCell
        cell.importanColorView.layer.cornerRadius = 25
        cell.importanColorView.backgroundColor = day.dayPlans[indexPath.row].importantColor
        cell.planTitle.text = day.dayPlans[indexPath.row].title
        cell.isCompletedLabel.layer.borderWidth = 1
        cell.isCompletedLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        if cell.importanColorView.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
            cell.importanColorView.layer.borderWidth = 1
            cell.importanColorView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        switch day.dayPlans[indexPath.row].isCompleted {
        case true: cell.isCompletedLabel.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case false: cell.isCompletedLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        default: break
        }
        cell.resignationHandler = { [weak self] in
            guard let self = self else { return }
            self.day.dayPlans[indexPath.row].isCompleted = !self.day.dayPlans[indexPath.row].isCompleted
            self.plansTableView.reloadData()
        }
        return cell
    }
    
}
