//
//  OtherPlansFromTabBarViewController.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/5/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class OtherPlansFromTabBarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   
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
        return PriorityPlans.sharedPlans.amountOfToDos
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = plansTableView.dequeueReusableCell(withIdentifier: "Priority Plan Identifier") as! PriorityPlansTableViewCell
        cell.importantColorView.layer.cornerRadius = 25
        cell.importantColorView.backgroundColor = PriorityPlans.sharedPlans.dayPlans[indexPath.row].importantColor
        cell.planTitle.text = PriorityPlans.sharedPlans.dayPlans[indexPath.row].title
        cell.isCompletedLabel.layer.borderWidth = 1
        cell.isCompletedLabel.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        if cell.importantColorView.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
            cell.importantColorView.layer.borderWidth = 1
            cell.importantColorView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        switch PriorityPlans.sharedPlans.dayPlans[indexPath.row].isCompleted {
        case true: cell.isCompletedImageView.image = UIImage.init(named: "check_button_icon")
        case false: cell.isCompletedImageView.image = UIImage()
        default: break
        }
        cell.resignationHandler = { [weak self] in
            guard let self = self else { return }
            PriorityPlans.sharedPlans.dayPlans[indexPath.row].isCompleted = !PriorityPlans.sharedPlans.dayPlans[indexPath.row].isCompleted
            self.saveChanges()
            self.plansTableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
            PriorityPlans.sharedPlans.dayPlans.remove(at: indexPath.row)
            plansTableView.deleteRows(at: [indexPath], with: .fade)
            saveChanges()
        } else if editingStyle == .insert {
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add New Priority Segue" {
            if let vc = segue.destination.contents as? AddNewPriorityViewController {
                vc.isChanging = false
            }
        } else {
            if segue.identifier == "Changing Existing Priority" {
                if let cell = sender as? PriorityPlansTableViewCell {
                    if let indexPath = plansTableView.indexPath(for: cell) {
                        if let vc = segue.destination as? AddNewPriorityViewController {
//                            print(indexPath.row)
//                            print(day.dayPlans[indexPath.row].title)
                            vc.dailyPlan = PriorityPlans.sharedPlans.dayPlans[indexPath.row]
                            vc.isChanging = true
                        }
                    }
                }
            }        }
    }
    
    func saveChanges() {
        if let json = PriorityPlans.sharedPlans.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
                ).appendingPathComponent("OtherFile.json") {
                do {
                    try json.write(to: url)
                    print("saved succefully!")
                } catch let error {
                    print("couldn't save\(error)")
                }
            }
            
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        plansTableView.reloadData()
        print("new batch")
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("OtherFile.json") {
            if let jsonData = try? Data(contentsOf: url) {
                PriorityPlans.sharedPlans = PriorityPlans(json: jsonData)!
            } else {
                print("Ok")
            }
        }

    }
}
