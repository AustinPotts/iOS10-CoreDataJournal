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
    
    
    func createEntry(with title: String, story: String, context: NSManagedObjectContext) {
        Entry(title: title, story: story, context: context)
        CoreDataStack.share.saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, title: String, story: String) {
        entry.title = title
        entry.story = story
        
        
        CoreDataStack.share.saveToPersistentStore()
        
    }
    
    
}
