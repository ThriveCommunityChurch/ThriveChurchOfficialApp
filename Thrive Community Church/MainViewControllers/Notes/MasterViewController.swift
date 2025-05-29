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

        // Ensure view background matches table view to prevent white bars
        view.backgroundColor = UIColor.almostBlack
    }

    // MARK: - Setup Views
    func setupTableView() {
        tableView.backgroundColor = UIColor.almostBlack
        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 80 // Increased height for card design
        tableView.register(ModernNotesTableViewCell.self, forCellReuseIdentifier: "Cell")

        // Add spacing for card layout
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        // Ensure table view extends to bottom edge without white bar
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        } else {
            automaticallyAdjustsScrollViewInsets = true
        }

        // Ensure table view fills entire view
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
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
                                             for: indexPath) as! ModernNotesTableViewCell

        let object = objects[(indexPath as NSIndexPath).row]
        let displayText = object == newNote ? "New Note" : object

        cell.configure(with: displayText)

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

// MARK: - Modern Notes Table View Cell

class ModernNotesTableViewCell: UITableViewCell {

    // MARK: - UI Elements

    // Card Container
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGrey
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Note Text Label
    private let noteTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Note Preview Label (for longer notes)
    private let notePreviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Disclosure Indicator
    private let disclosureIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup Methods

    private func setupViews() {
        backgroundColor = .almostBlack
        selectionStyle = .none

        // Configure cell appearance
        layer.masksToBounds = false

        // Add main container
        contentView.addSubview(cardContainer)

        // Add content to card
        cardContainer.addSubview(noteTextLabel)
        cardContainer.addSubview(notePreviewLabel)
        cardContainer.addSubview(disclosureIndicator)

        setupConstraints()
    }

    private func setupConstraints() {
        // Create bottom constraint with lower priority to avoid conflicts
        let bottomConstraint = cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        bottomConstraint.priority = UILayoutPriority(999) // High but not required

        NSLayoutConstraint.activate([
            // Card container constraints with adaptive width for iPad
            cardContainer.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 4),
            bottomConstraint,
            cardContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // Width constraints for adaptive layout
            cardContainer.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            cardContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 600), // Maximum width for readability

            // Prefer to fill available width but respect maximum
            {
                let widthConstraint = cardContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32)
                widthConstraint.priority = .defaultHigh
                return widthConstraint
            }(),

            // Minimum height constraint to prevent zero-height issues
            cardContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 72),

            // Note text label constraints
            noteTextLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            noteTextLabel.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            noteTextLabel.trailingAnchor.constraint(equalTo: disclosureIndicator.leadingAnchor, constant: -12),

            // Note preview label constraints
            notePreviewLabel.topAnchor.constraint(equalTo: noteTextLabel.bottomAnchor, constant: 4),
            notePreviewLabel.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            notePreviewLabel.trailingAnchor.constraint(equalTo: disclosureIndicator.leadingAnchor, constant: -12),
            notePreviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardContainer.bottomAnchor, constant: -12),

            // Disclosure indicator constraints
            disclosureIndicator.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            disclosureIndicator.widthAnchor.constraint(equalToConstant: 8),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    // MARK: - Configuration

    func configure(with noteText: String) {
        if noteText == "New Note" || noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            noteTextLabel.text = "New Note"
            noteTextLabel.textColor = .lightGray
            notePreviewLabel.text = "Tap to start writing..."
            notePreviewLabel.isHidden = false
        } else {
            // Split the note into title and preview
            let lines = noteText.components(separatedBy: .newlines)
            let firstLine = lines.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            if firstLine.isEmpty {
                noteTextLabel.text = "Note"
                noteTextLabel.textColor = .white
            } else {
                noteTextLabel.text = firstLine
                noteTextLabel.textColor = .white
            }

            // Show preview if there's more content
            if lines.count > 1 {
                let remainingText = lines.dropFirst().joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                if !remainingText.isEmpty {
                    notePreviewLabel.text = remainingText
                    notePreviewLabel.isHidden = false
                } else {
                    notePreviewLabel.isHidden = true
                }
            } else {
                notePreviewLabel.isHidden = true
            }
        }
    }

    // MARK: - Touch Animation

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animatePress(pressed: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animatePress(pressed: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animatePress(pressed: false)
    }

    private func animatePress(pressed: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction) {
            self.transform = pressed ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            self.cardContainer.layer.shadowOpacity = pressed ? 0.2 : 0.4
        }
    }
}