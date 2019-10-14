//
//  Entry+Convenience.swift
//  iOS10-JournalApp
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData


extension Entry {
    
    @discardableResult convenience init(title: String, story: String, timeStamp: Date , context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.title = title
        self.story = story
        self.timeStamp = timeStamp
        
        
    }
    
    
    
    
}
