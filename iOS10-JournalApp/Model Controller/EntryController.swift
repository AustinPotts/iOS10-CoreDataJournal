//
//  EntryController.swift
//  iOS10-JournalApp
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}


class EntryController {
    
    //Establish URL Base
    let baseURL = URL(string: "https://ios10-journal.firebaseio.com/")!
    
    
    func fetchEntryFromServer(completion: @escaping ()-> Void = { } ){
        
        //Set up the URL
        let requestURL = baseURL.appendingPathExtension("json")
        
        //Create the URLRequest
        var request = URLRequest(url: requestURL)
        
        //Perform Data Task
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("Error fetchign data")
                completion()
                return
            }
            
            
            let decoder = JSONDecoder()
            
            
            do {
                let entry = try decoder.decode([String: EntryRepresentation].self, from: data).map({ $0.value })
                
                self.updateEntry(with: entry)
                
            } catch {
                NSLog("Error decoding TaskRep: \(error)")
                
            }
            
            completion()
            
            }.resume()
        
    }
    
    
    func updateEntry(with representations: [EntryRepresentation]){
        
        
        
        let identifiersToFetch = representations.map({ $0.identifier })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        
        var tasksToCreate = representationsByID
        
        do {
            let context = CoreDataStack.share.mainContext
            
            let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
            //Only fetch the tasks with identifiers that are in this identifersToFetch array
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            
            let exisitingEntry = try context.fetch(fetchRequest)
            
            //Update the ones we have
            for entry in exisitingEntry {
                
                // Grab the task representation that corresponds to this task
                guard let identifier = entry.identifier,
                    let representation = representationsByID[identifier]else { continue }
                
               entry.title = representation.title
               entry.story = representation.story
                entry.risk = representation.risk
                
                //We just updated a Task, we dont need to create a new Task for this identifier
                tasksToCreate.removeValue(forKey: identifier)
            }
            
            //Figure out which We dont have
            for representation in tasksToCreate.values {
                
                Entry(entryRepresentation: representation, context: context)
               // Task(taskRepresentation: representation, context: context)
            }
            
            
            
            CoreDataStack.share.saveToPersistentStore()
        } catch {
            NSLog("Error fetching tasks from persistence store: \(error)")
            
        }
        
        
    }
    
    
    func putEntry(entry: Entry, completion: @escaping ()-> Void = { }){
        
        //Find a unique place to put this task
        let identifier = entry.identifier ?? UUID()
        entry.identifier = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let entryRepresentation = entry.entryRepresentation else {
            NSLog("Entry Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(entryRepresentation)
        } catch {
            NSLog("Error encoding entry representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error PUTting task: \(error)")
                completion()
                return
            }
            
            completion()
            }.resume()
        
        
        
    }

    
    
    
    
    func createEntry(with title: String, story: String, risk: RiskCase, context: NSManagedObjectContext) {
       let entry = Entry(title: title, story: story, risk: risk, context: context)
        CoreDataStack.share.saveToPersistentStore()
        putEntry(entry: entry)
    }
    
    func updateEntry(entry: Entry, title: String, story: String, risk: RiskCase) {
        entry.title = title
        entry.story = story
        entry.risk = risk.rawValue 
        
        
        CoreDataStack.share.saveToPersistentStore()
        putEntry(entry: entry)
        
    }
    
    
}
