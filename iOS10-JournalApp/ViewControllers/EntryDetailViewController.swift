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
            
            //check which segment is selected and create a string constant that holds the corresponding mood
            let index = riskLevelSegmentedControl.selectedSegmentIndex
            let risk = RiskCase.allCases[index]
            
            if let entry = entry {
                entryController?.updateEntry(entry: entry, title: title, story: story, risk: risk)
            } else {
                entryController?.createEntry(with: title, story: story, risk: risk, context: CoreDataStack.share.mainContext)
            }
            
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func updateViews(){
        
        guard isViewLoaded else{return}
        
        title = entry?.title ?? "Create Story"
        titleTextField.text = entry?.title
        entryTextField.text = entry?.story
        
        if let riskString = entry?.risk,
            let risk = RiskCase(rawValue: riskString) {
            
            let index = RiskCase.allCases.firstIndex(of: risk) ?? 0
            
            riskLevelSegmentedControl.selectedSegmentIndex = index
        }
        
    }
    
}
