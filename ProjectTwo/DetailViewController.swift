//
//  DetailViewController.swift
//  ProjectTwo
//
//  Created by Lincoln Stewart on 10/17/22.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var prioritySlider: UISlider!
    @IBOutlet var priorityValueLabel: UILabel!
    @IBOutlet var addTask: UIButton!
    
    var taskStore: TaskStore!
    
    var task: Task!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
            
        priorityValueLabel.text = "\(currentValue)"
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        
        let taskName = nameField.text ?? ""
        let taskPriority = self.priorityValueLabel.text
        
        let taskDict:[String: Any] = ["taskName": taskName, "taskPriority": taskPriority]
        
        if (!taskName.trimmingCharacters(in: .whitespaces).isEmpty) {
            print("Outgoing taskDict: ", taskDict)
            NotificationCenter.default.post(name: Notification.Name("taskAdded"), object: nil, userInfo: taskDict)
            self.navigationController?.popViewController(animated: true)
            print("taskAdded notification sent")
        } else {
            // Implement UI validation here if I have time
            print("Task name validation failed")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
    }

}
