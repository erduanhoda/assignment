//
//  AssignmentService.swift
//  Assignment
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 TheDeveloperEd. All rights reserved.
//

import Foundation

class AssignmentService {
    var assignments = [[Assignment](), [Assignment]()]
    
    func add(assignment: Assignment, isDone: Bool = false, index: Int) {
        let section = isDone == true ? 1 : 0
        assignments[section].insert(assignment, at: index)
    }
    
    @discardableResult func remove(index: Int, isDone: Bool = false) -> Assignment {
        let section = isDone == true ? 1 : 0
        return assignments[section].remove(at: index)
    }
}
