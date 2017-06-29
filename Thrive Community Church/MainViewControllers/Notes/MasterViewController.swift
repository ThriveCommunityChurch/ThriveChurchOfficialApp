//
//  MasterViewController.swift
//  notes
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Wyatt Baggett. All rights reserved.
//

import UIKit

var objects:[String] = [String]()
var currentIndex:Int = 0
var masterView:MasterViewController?
var detailViewController:DetailViewController?

let kNotes:String = "notes"
let BLANK_NOTE:String = "New Note"

class MasterViewController: UITableViewController {
    
/*
     There is an issue in the class where when the user hits the notes button,
     the view loads the notes page - "DetailView" and if the user hits back then
     the note is automatically deleted.
     
     Adding save() calls will not fix this. Perhaps calling a method in some other
     way or program it by hand is more beneficial.
     
*/    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        masterView = self
        
        load()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        save()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if objects.count == 0 {
            insertNewObject(self)
        }
        save()
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func insertNewObject(_ sender: AnyObject) {
        save()
        
        if objects.count == 0 || objects[0] != BLANK_NOTE {
            
            objects.insert(BLANK_NOTE, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            
            save()
        }
        save()
        
        currentIndex = 0
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    // MARK: - Segues
    
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
    
    // MARK: - Table View
    
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
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class,
            //insert it into the array, and add a new row to the table view.
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            return
        }
        save()
    }
    
    override func tableView(_ tableView: UITableView,
                                didEndEditingRowAt indexPath: IndexPath?) {
        save()
    }
    
    func save() {
        UserDefaults.standard.set(objects, forKey: kNotes)
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        
        if let loadedData = UserDefaults.standard.array(forKey: kNotes) as? [String] {
            objects = loadedData
        }
    }
}
