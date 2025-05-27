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
let newNote: String = "New Note"

class MasterViewController: UITableViewController {


	// TODO: Issue #71

	// TODO: Clean these classes up a bunch
	// theres a log going on here and it's hard to follow

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationBar()

        masterView = self
        // Called when the user Taps "Notes" icon -- buttons are all added before the segue
        load()
    }

    // MARK: - Setup Views
    func setupTableView() {
        tableView.backgroundColor = UIColor.almostBlack
        tableView.separatorColor = UIColor.gray
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func setupNavigationBar() {
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = false

        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Clear selection when returning to this view
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }

        save()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Gets called when the user is returning from writing a note
        // Do this in viewDidAppear to ensure table view is in hierarchy
        if objects.isEmpty {
            insertNewObjectSilently()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        currentIndex = indexPath.row

        let detailVC = DetailViewController()
        detailVC.detailItem = object as AnyObject?
        detailViewController = detailVC

        navigationController?.pushViewController(detailVC, animated: true)
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
		cell.backgroundColor = UIColor.almostBlack
		cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15)
		cell.textLabel?.textColor = UIColor.white
		cell.textLabel?.numberOfLines = 2
        cell.textLabel!.text = object == newNote ? "New Note" : object
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt
                                                indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit
		editingStyle: UITableViewCell.EditingStyle,
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
		// Ensure we have a new note to add
		if objects.isEmpty || objects[0] != newNote {
			// Update data source first
			objects.insert(newNote, at: 0)

			// Then update table view
			let indexPath = IndexPath(row: 0, section: 0)
			tableView.insertRows(at: [indexPath], with: .automatic)

			save()
		}

		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-NotesMasterVC",
			AnalyticsParameterItemName: "InsertNewNote",
			AnalyticsParameterContentType: "cont"
		])

		currentIndex = 0

		// Navigate to detail view programmatically
		let detailVC = DetailViewController()
		detailVC.detailItem = objects[0] as AnyObject?
		detailViewController = detailVC

		navigationController?.pushViewController(detailVC, animated: true)
	}

	// Silent version for initial setup - doesn't navigate
	func insertNewObjectSilently() {
		if objects.isEmpty {
			objects.insert(newNote, at: 0)
			tableView.reloadData() // Use reload instead of insert to avoid batch update issues
			save()
		}
	}

    func save() {
        UserDefaults.standard.set(objects, forKey: ApplicationVariables.NotesCacheKey)
        UserDefaults.standard.synchronize()

		Analytics.logEvent(AnalyticsEventLevelEnd, parameters: [
			AnalyticsParameterItemID: "id-NotesMasterVC",
			AnalyticsParameterItemName: "SaveFor-\(objects.count)",
			AnalyticsParameterContentType: "cont"
		])
    }

    func load() {
        if let loadedData = UserDefaults.standard.array(forKey: ApplicationVariables.NotesCacheKey) as? [String] {
            objects = loadedData
        }

		Analytics.logEvent(AnalyticsEventLevelStart, parameters: [
			AnalyticsParameterItemID: "id-NotesMasterVC",
			AnalyticsParameterItemName: "LoadFor-\(objects.count)",
			AnalyticsParameterContentType: "cont"
		])
    }

}
