//
//  CoreDataStack.swift
//  iOS10-JournalApp
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let share = CoreDataStack()
    
    private init() {
        
    }
    
    //Create Code Snippet
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Entries")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading Persistent Stores: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }() // Creating only one instance for use
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.share.mainContext) {
        
        context.performAndWait {
            
        
        do{
            try context.save()
        } catch {
            NSLog("Error saving context \(error)")
            context.reset()
        }
        }
    }
    
    
}
