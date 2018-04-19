//
//  DataService.swift
//  Assignment
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 TheDeveloperEd. All rights reserved.
//

import Foundation

class DataService {
    private static func archive (assignments: [[Assignment]]) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: assignments) as NSData
    }
    
    static func fetch() -> [[Assignment]]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: "assignments") as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: unarchivedData) as? [[Assignment]]
    }
    
    static func save(assignments: [[Assignment]]) {
        let archivedAssignments = archive(assignments: assignments)
        UserDefaults.standard.set(archivedAssignments, forKey: "assignments")
        UserDefaults.standard.synchronize()
    }
}
