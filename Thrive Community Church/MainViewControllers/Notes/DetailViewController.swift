//
//  DetailViewController.swift
//  notes
//
//  Created by Wyatt Baggett on 8/1/16.
//  Copyright © 2016 Wyatt Baggett. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController, UITextViewDelegate {

    let detailDescriptionLabel: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.white
        textView.textColor = UIColor.black
        textView.font = UIFont(name: "AvenirNext-Regular", size: 17)
        textView.keyboardDismissMode = .onDrag
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigationBar()

        detailViewController = self
		detailDescriptionLabel.delegate = self
        detailViewController?.becomeFirstResponder()

        saveAndUpdate()
		// it is important that this be in here a second time -- notes have issues otherwise
        self.configureView()

		// Analytics
		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-NotesDetailVC",
			AnalyticsParameterItemName: "NotesDetailVC-init",
			AnalyticsParameterContentType: "cont"
		])
    }

    var detailItem: AnyObject? {
        didSet {
            saveAndUpdate()
        }
    }

    // runs even before the segue happens
    func configureView() {
        // Update the user interface for the detail item.
        saveAndUpdate()

        if objects.isEmpty {
            return
        }

        detailDescriptionLabel.text = objects[currentIndex]

        if detailDescriptionLabel.text == newNote {
            detailDescriptionLabel.text = ""
        }
    }

	// MARK: - UITextViewDelegate
	func textViewDidChangeSelection(_ textView: UITextView) {
		if let selectedRange = detailDescriptionLabel.selectedTextRange {
			let startPos = detailDescriptionLabel.beginningOfDocument
			let cursorPosition = detailDescriptionLabel.offset(from: startPos, to: selectedRange.start)
			let length = max(0, cursorPosition - 1)
			detailDescriptionLabel.scrollRangeToVisible(NSRange(location: cursorPosition, length: length))
		}
	}

	func textViewDidChange(_ textView: UITextView) {
		// Auto-save as user types
		if objects.isEmpty {
			return
		}

		let indexText = detailDescriptionLabel.text ?? ""
		objects[currentIndex] = indexText.isEmpty ? newNote : indexText
	}

	// MARK: - Setup Views
	func setupViews() {
		view.backgroundColor = UIColor.white
		view.addSubview(detailDescriptionLabel)

		NSLayoutConstraint.activate([
			detailDescriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			detailDescriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			detailDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			detailDescriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])
	}

	func setupNavigationBar() {
		navigationItem.title = "Notes"

		let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
		let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))

		navigationItem.rightBarButtonItems = [saveButton, shareButton]
	}

	@objc func saveNote() {
		// Force save the current note
		saveAndUpdate()

		// Show confirmation
		let alert = UIAlertController(title: "Saved", message: "Your note has been saved successfully.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)

		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-NotesDetailVC",
			AnalyticsParameterItemName: "ManualSave",
			AnalyticsParameterContentType: "cont"
		])
	}

    @objc func share() {

		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-NotesDetailVC",
			AnalyticsParameterItemName: "Share",
			AnalyticsParameterContentType: "cont"
		])

		guard let textToShare = detailDescriptionLabel.text else { return }

		let objectsToShare = [textToShare]
		let activityVC = UIActivityViewController(activityItems: objectsToShare,
												  applicationActivities: nil)

		activityVC.popoverPresentationController?.sourceView = view
		self.present(activityVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		// Issue #70
		if detailDescriptionLabel.text == "New Note" || detailDescriptionLabel.text == "New Note " {
			detailDescriptionLabel.text = "New Note "
		}
	}

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if objects.isEmpty {
            return
        }

        // updates the text for the preview of the note on the Table View
		let indexText = detailDescriptionLabel.text ?? ""
		objects[currentIndex] = indexText

		if detailDescriptionLabel.text == "" {
			objects[currentIndex] = newNote
		}

		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-NotesDetailVC",
			AnalyticsParameterItemName: "Dismiss",
			AnalyticsParameterContentType: "cont"
		])

        saveAndUpdate()
    }

    // permiate changes to the master view
    func saveAndUpdate() {
        masterView?.save()
        masterView?.tableView.reloadData()
    }

}

class ActivityForNotesViewController: UIActivityViewController {

    // Remove non-text actions
    internal func _shouldExcludeActivityType(_ activity: UIActivity) -> Bool {
        let activityTypesToExclude = [
            "com.apple.reminders.RemindersEditorExtension",
			UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            "com.google.Drive.ShareExtension",
            "com.apple.mobileslideshow.StreamShareService"
        ] as [Any]

        if let actType = activity.activityType {
            if activityTypesToExclude.contains(where: { (Any) -> Bool in
                return true
            }) {
                return true
            }
            else if super.excludedActivityTypes != nil {
                return super.excludedActivityTypes!.contains(actType)
            }
        }
        return false
    }

}
