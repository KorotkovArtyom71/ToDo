//
//  AddNewPriorityViewController.swift
//  DailyPlanner
//
//  Created by artyom korotkov on 12/15/18.
//  Copyright © 2018 artyom korotkov. All rights reserved.
//

import UIKit

class AddNewPriorityViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    var selectedColorIndex = 0
    var date = Date()
    var colorArray = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1),#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.4140892551),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
    override func awakeFromNib() {
        super.awakeFromNib()
        textField?.isEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(activateTextField))
        tapGesture.numberOfTapsRequired = 1
        textField?.addGestureRecognizer(tapGesture)
        self.title = "Add Priority"
    }
    
    
    @objc func activateTextField() {
        textField?.isEnabled = true
        textField?.becomeFirstResponder()
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textField.layer.borderWidth = 1
            textField.borderStyle = .roundedRect
        }
    }
    
    var resignationHandler: (() -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBOutlet weak var chooseColorCollectionView: UICollectionView! {
        didSet {
            chooseColorCollectionView.dataSource = self
            chooseColorCollectionView.delegate = self
            //if let flowLayout
            //chooseColorCollectionView.collectionViewLayout
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Color Choose Collection View Identifier", for: indexPath) as! PriorityChooseColorCollectionViewCell
        switch indexPath.item {
        case 0:
            cell.rootView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.rootView.layer.borderWidth = 1
            cell.rootView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        case 1: cell.rootView.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        case 2: cell.rootView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case 3: cell.rootView.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        case 4: cell.rootView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case 5: cell.rootView.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.4140892551)
        case 6: cell.rootView.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case 7: cell.rootView.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case 8: cell.rootView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case 9: cell.rootView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case 10: cell.rootView.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        case 11: cell.rootView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        default: break
        }
        cell.selectedImageView.image = UIImage(named: "check_button_icon")!
        if indexPath.row == selectedColorIndex {
            cell.selectedImageView.alpha = 1.0
        } else {
            cell.selectedImageView.alpha = 0.0
        }
        cell.rootView.layer.cornerRadius = 25
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedColorIndex = indexPath.row
        collectionView.reloadData()
    }
    
    
    @IBAction func addNewToDoButton(_ sender: UIButton) {
        let plan = DailyPlan(isCompleted: false, day: date, importantColor: colorArray[selectedColorIndex], title: textField.text!)
        do {
            let data = try JSONEncoder().encode(plan)
            print(String(data: data, encoding: .utf8)!)
            let newTask = try JSONDecoder().decode(DailyPlan.self, from: data)
            print(newTask)
        } catch {  print(error) }
        PriorityPlans.sharedPlans.dayPlans.append(plan!)
        if let json = DaysManager.shared.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
                ).appendingPathComponent("Untitled2.json") {
                do {
                    try json.write(to: url)
                    print("saved succefully!")
                } catch let error {
                    print("couldn't save\(error)")
                }
            }
            
        }
        self.navigationController?.popViewController(animated: true)
    }
}
