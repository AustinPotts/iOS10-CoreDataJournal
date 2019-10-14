//
//  EntriesTableViewController.swift
//  iOS10-JournalApp
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class EntriesTableViewController: UITableViewController {

    var entryController = EntryController()
    
    
    //Improper fetch
    var entry: [Entry] {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        let moc = CoreDataStack.share.mainContext
        
        do {
          let entry = try moc.fetch(fetchRequest)
            return entry
        } catch {
            NSLog("Erorr fetching: \(error)")
            return []
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entry.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)

        cell.textLabel?.text = entry[indexPath.row].title
        return cell
    }
    

   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "ShowEntryDetailSegue" {
            if let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                detailVC.entry = entry[indexPath.row]
                detailVC.entryController = entryController
                
            }
        } else if segue.identifier == "AddEntrySegue" {
            
            if let detailVC = segue.destination as? EntryDetailViewController {
                detailVC.entryController = entryController
            }
        }
        
    }
    

}
