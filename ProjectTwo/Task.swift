//
//  Task.swift
//  ProjectTwo
//
//  Created by Lincoln Stewart on 10/10/22.
//

import UIKit

class Task: Equatable, Codable {
    var name: String
    var priority: Int
    var completed: Bool
    
    init(name: String, priority: Int) {
        self.name = name
        self.priority = priority
        self.completed = false
    }
    
    static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.name == rhs.name
            && lhs.priority == rhs.priority
            && lhs.completed == rhs.completed
    }
}
