//
//  TaskStore.swift
//  ProjectTwo
//
//  Created by Lincoln Stewart on 10/10/22.
//

import UIKit

class TaskStore {

    var allTasks = [Task]()
    let taskArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("tasks.plist")
    }()
    
    // I know this is bad practice, will use gaurd statement in the future.
    var priorityInt = Int()
    
    init() {
        do {
            let data = try Data(contentsOf: taskArchiveURL)
            let unarchiver = PropertyListDecoder()
            let tasks = try unarchiver.decode([Task].self, from: data)
            allTasks = tasks
        } catch {
            print("Error reading in saved tasks: \(error)")
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    @discardableResult func createTask(name: String, priority: String) -> Task {
        if let priorityInt = Int(priority) {
            print("Unwrapped priority int: ", priorityInt)
            self.priorityInt = priorityInt
        }
        
        let newTask = Task(name: name, priority: Int(priorityInt))

        allTasks.append(newTask)

        return newTask
    }
    
    func removeTask(_ task: Task) {
        if let index = allTasks.firstIndex(of: task) {
            allTasks.remove(at: index)
        }
    }
    
    @objc func saveChanges() -> Bool {
        print("Saving tasks to: \(taskArchiveURL)")
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allTasks)
            try data.write(to: taskArchiveURL, options: [.atomic])
            print("Saved all of the tasks")
            return true
        } catch let encodingError {
            print("Error encoding allTasks: \(encodingError)")
            return false
        }

    }

}
