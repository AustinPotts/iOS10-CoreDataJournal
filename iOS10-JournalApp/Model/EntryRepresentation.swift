//
//  EntryRepresentation.swift
//  iOS10-JournalApp
//
//  Created by Austin Potts on 10/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation


struct EntryRepresentation: Codable {
    
    let title: String
    let story: String?
    let risk: String
    let identifier: UUID
    
    
}
