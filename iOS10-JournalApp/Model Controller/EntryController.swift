//
//  EntryController.swift
//  iOS10-JournalApp
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData


class EntryController {
    
    
    func createEntry(with title: String, story: String, risk: RiskCase, context: NSManagedObjectContext) {
        Entry(title: title, story: story, risk: risk, context: context)
        CoreDataStack.share.saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, story: String, risk: RiskCase) {
        entry.title = title
        entry.story = story
        entry.risk = risk.rawValue 
        
        
        CoreDataStack.share.saveToPersistentStore()
        
    }
    
    
}
