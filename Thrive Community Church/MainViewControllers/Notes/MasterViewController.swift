//
//  MasterViewController.swift
//  notes
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Wyatt Baggett. All rights reserved.
//

import UIKit
import Firebase

var objects: [String] = [String]()
var currentIndex: Int = 0
var masterView: MasterViewController?
var detailViewController: DetailViewController?
let notesKey: String = "notes"
let newNote: String = "New Note"

class MasterViewController: UITableViewController {
	
	
	// TODO: Issue #71
	
	// TODO: Clean these classes up a bunch
	// theres a log going on here and it's hard to follow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        masterView = self
        // Called when the user Taps "Notes" icon -- buttons are all added before the segue
        load()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        // Gets called when the user is returning from writing a note
        
        if objects.count == 0 {
            insertNewObject(self)
        }
        
        save()
        /*
         Adding insert new object here in this method is not working - creates an inifinte loop
         of creating a new table item - but keeps copying the text from other notes to the new one
        */
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
			
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let object = objects[(indexPath as NSIndexPath).row]
                currentIndex = (indexPath as NSIndexPath).row
                
                detailViewController?.detailItem = object as AnyObject?
                detailViewController?.navigationItem.leftBarButtonItem =
                            self.splitViewController?.displayModeButtonItem
                detailViewController?.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: Table View Logic
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection
                                                        section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                             for: indexPath)
        
        let object = objects[(indexPath as NSIndexPath).row]
		cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
        cell.textLabel!.text = object
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt
                                                indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit
                                        editingStyle: UITableViewCellEditingStyle,
                                        forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            objects.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
			
			Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
				AnalyticsParameterItemID: "id-NotesMasterVC",
				AnalyticsParameterItemName: "RemoveNote-AtIndex-\(indexPath.row)",
				AnalyticsParameterContentType: "cont"
			])
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class,
            // insert it into the array, and add a new row to the table view.
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        // selecting an item to be deleted / has been removed - Called multiple times
        // for various editing tasks
        if editing {
            return
        }
        save()
        
    }
    
    override func tableView(_ tableView: UITableView,
                                didEndEditingRowAt indexPath: IndexPath?) {
        save()
    }
	
	// MARK: Other Functions
	
	// Adds new object & changes name of the string of Master following the segue back
	@objc func insertNewObject(_ sender: AnyObject) {
		
		if objects.count == 0 || objects[0] != newNote {
			
			objects.insert(newNote, at: 0)
			let indexPath = IndexPath(row: 0, section: 0)
			self.tableView.insertRows(at: [indexPath], with: .automatic)
			
			save()
		}
		save()
		
		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-NotesMasterVC",
			AnalyticsParameterItemName: "InsertNewNote",
			AnalyticsParameterContentType: "cont"
		])
		
		currentIndex = 0
		self.performSegue(withIdentifier: "showDetail", sender: self)
	}
    
    func save() {
        UserDefaults.standard.set(objects, forKey: notesKey)
        UserDefaults.standard.synchronize()
		
		Analytics.logEvent(AnalyticsEventLevelEnd, parameters: [
			AnalyticsParameterItemID: "id-NotesMasterVC",
			AnalyticsParameterItemName: "SaveFor-\(objects.count)",
			AnalyticsParameterContentType: "cont"
		])
    }
    
    func load() {
        if let loadedData = UserDefaults.standard.array(forKey: notesKey) as? [String] {
            objects = loadedData
        }
		
		Analytics.logEvent(AnalyticsEventLevelStart, parameters: [
			AnalyticsParameterItemID: "id-NotesMasterVC",
			AnalyticsParameterItemName: "LoadFor-\(objects.count)",
			AnalyticsParameterContentType: "cont"
		])
    }
    
}
