//
//  Assignment.swift
//  Assignment
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 TheDeveloperEd. All rights reserved.
//

import Foundation

class Assignment : NSObject, NSCoding {
    var name: String?
    var isDone: Bool?
    
    init(name: String, isDone: Bool = false) {
        self.name = name
        self.isDone = isDone
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(isDone, forKey: "isDone")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
              let isDone = aDecoder.decodeObject(forKey: "isDone") as? Bool
            else { return }
        
        self.name = name
        self.isDone = isDone
    }
}
