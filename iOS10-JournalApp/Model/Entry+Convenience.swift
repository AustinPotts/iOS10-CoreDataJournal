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
    
    
    var entryRepresentation: EntryRepresentation? {
        guard let title = title,
        let risk = risk,
            let identifier = identifier else {return nil}
        
        return EntryRepresentation(title: title, story: story, risk: risk, identifier: identifier)
    }
    
    
    @discardableResult convenience init(title: String, story: String?, risk: RiskCase, identifier: UUID = UUID(), context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.story = story
        self.risk = risk.rawValue
        self.identifier = identifier 
        
    }
    
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext){
        
        guard let risk = RiskCase(rawValue: entryRepresentation.risk) else {return nil }
        
        self.init(title: entryRepresentation.title, story: entryRepresentation.story, risk: risk, identifier: entryRepresentation.identifier, context: context)
        
        
    }
    
    
    
}
