//
//  Entry+Convenience.swift
//  iOS10-JournalApp
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum RiskCase: String, CaseIterable {
    case 🤧
    case 🤢
    case 🤮
    case 💀
    
}


extension Entry {
    
    @discardableResult convenience init(title: String, story: String, risk: RiskCase, identifier: UUID = UUID(), context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.story = story
        self.risk = risk.rawValue
        self.identifier = identifier 
        
        
        
    }
    
    
    
    
}
