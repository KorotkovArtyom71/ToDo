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
        case true: cell.isCompletedImage.image = UIImage.init(named: "check_button_icon")
        case false: cell.isCompletedImage.image = UIImage()
        default: break
        }
        cell.resignationHandler = { [weak self] in
            guard let self = self else { return }
            self.day.dayPlans[indexPath.row].isCompleted = !self.day.dayPlans[indexPath.row].isCompleted
            self.saveChanges()
        }
        return cell
    }
    
    func saveChanges() {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        plansTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = plansTableView.dequeueReusableCell(withIdentifier: "ToDo For Some Day Identifier", for: indexPath) as! PlansForSomeDayTableViewCell
        //performSegue(withIdentifier: "Changing Existing ToDo", sender: cell)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DaysManager.shared.dayForDate(for: day.date).dayPlans.remove(at: indexPath.row)
            plansTableView.deleteRows(at: [indexPath], with: .fade)
            saveChanges()
        } else if editingStyle == .insert {
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Changing Existing ToDo" {
            if let cell = sender as? PlansForSomeDayTableViewCell {
                if let indexPath = plansTableView.indexPath(for: cell) {
                    if let vc = segue.destination as? AddNewToDoViewController {
                        print(indexPath.row)
                        print(day.dayPlans[indexPath.row].title)
                        vc.dailyPlan = day.dayPlans[indexPath.row]
                        vc.isChanging = true
                    }
                }
            }
        }
    }
    
}
