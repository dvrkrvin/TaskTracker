//
//  TasksViewController.swift
//  ProjectTwo
//
//  Created by Lincoln Stewart on 10/10/22.
//

import UIKit

class TasksViewController: UITableViewController {
    
    var taskStore: TaskStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        navigationItem.leftBarButtonItem = editButtonItem
    }
    
     // NOTE: Called when taskAdded notification is received
    @objc func addNewTask(_ notification: NSNotification) {
        
        print("Add new task method fired")
        
        if let unwrappedTN = notification.userInfo!["taskName"] as? String {
            print("Unwrapped TN: ", unwrappedTN)
            if let unwrappedTP = notification.userInfo!["taskPriority"] as? String {
                print("Unwrapped TP: ", unwrappedTP)
                
                let newTask = taskStore.createTask(name: unwrappedTN, priority: unwrappedTP)
                
                if let index = taskStore.allTasks.firstIndex(of: newTask) {
                    let indexPath = IndexPath(row: index, section: 0)

                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
            numberOfRowsInSection section: Int) -> Int {
        return taskStore.allTasks.count
    }
    
    override func tableView(_ tableView: UITableView,
            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        
        let task = taskStore.allTasks[indexPath.row]
        
        cell.nameLabel.text = task.name
        cell.priorityLabel.text = String(task.priority)

        
        if (task.completed == true) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let task = taskStore.allTasks[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = UITableViewCell.AccessoryType.none
            } else {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
            task.completed = !task.completed
            
            print("Task Completion Status: \(task.completed)")
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskStore.allTasks[indexPath.row]
            taskStore.removeTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTask(_:)), name:Notification.Name("taskAdded"), object: nil)
    }

}
