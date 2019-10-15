//
//  EntryDetailViewController.swift
//  iOS10-JournalApp
//
//  Created by Austin Potts on 10/14/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var entryTextField: UITextView!
    @IBOutlet weak var riskLevelSegmentedControl: UISegmentedControl!
    
    var entry: Entry?
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    

    
    @IBAction func save(_ sender: Any) {
        
        if let title = titleTextField.text,
            let story = entryTextField.text {
            
            if let entry = entry {
                entryController?.updateEntry(entry: entry, title: title, story: story)
            } else {
                entryController?.createEntry(with: title, story: story, context: CoreDataStack.share.mainContext)
            }
            
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func updateViews(){
        
        guard isViewLoaded else{return}
        
        title = entry?.title ?? "Create Story"
        titleTextField.text = entry?.title
        entryTextField.text = entry?.story
        
    }
    
}
