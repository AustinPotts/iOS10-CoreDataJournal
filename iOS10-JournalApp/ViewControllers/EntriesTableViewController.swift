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
    
    
    
    lazy var fetchResultController: NSFetchedResultsController<Entry> = {
        
        //Create Fetch request
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        //Sort the fetched results
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "risk", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.share.mainContext, sectionNameKeyPath: "risk", cacheName: nil)
        
        frc.delegate = self
        
        do{
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
        
    }()
    
//    //Improper fetch
//    var entry: [Entry] {
//
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//
//        let moc = CoreDataStack.share.mainContext
//
//        do {
//          let entry = try moc.fetch(fetchRequest)
//            return entry
//        } catch {
//            NSLog("Erorr fetching: \(error)")
//            return []
//        }
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 0
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)

        
        let entry = fetchResultController.object(at: indexPath)
        cell.textLabel?.text = entry.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sectionInfo = fetchResultController.sections?[section] else {return nil}
        
        return sectionInfo.name.capitalized
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else{return }
        
        let entry = fetchResultController.object(at: indexPath)
        
        entryController.delete(entry: entry)
    }

   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "ShowEntryDetailSegue" {
            if let detailVC = segue.destination as? EntryDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                let entry = fetchResultController.object(at: indexPath)
                
                detailVC.entry = entry
                detailVC.entryController = entryController
                
            }
        } else if segue.identifier == "AddEntrySegue" {
            
            if let detailVC = segue.destination as? EntryDetailViewController {
                detailVC.entryController = entryController
            }
        }
        
    }
    

}

extension EntriesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else{return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete:
            guard let indexPath = indexPath else{return}
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else{return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
            
        case .update:
            guard let indexPath = indexPath else{return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        @unknown default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let sectionSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(sectionSet, with: .automatic)
            
        case .delete:
            tableView.deleteSections(sectionSet, with: .automatic)
            
        default: return
        }
        
    }
    
}
