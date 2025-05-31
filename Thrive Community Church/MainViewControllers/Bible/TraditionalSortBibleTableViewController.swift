//
//  TraditionalSortBibleTableViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 6/21/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit
import Firebase

class TraditionalSortBibleTableViewController: UITableViewController {

	private var reuseIdentifier = "Cell"
	var biblePassages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

		biblePassages = self.getUrlforTraditionalBookOrder()

		tableView.register(BibleSelectionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

		// Always 1 pixel off after the removal
		tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: -1, right: 0)

		tableView?.backgroundColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1.0)
		tableView?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

		// Ensure view background matches table view to prevent white bars
		view.backgroundColor = UIColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1.0)

		// Ensure table view extends to bottom edge without white bar (iOS 15+ minimum deployment target)
		tableView.contentInsetAdjustmentBehavior = .automatic

		// Ensure table view fills entire view
		extendedLayoutIncludesOpaqueBars = true
		edgesForExtendedLayout = .all
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 66
    }

	// Removing the annoying header and footers from static cells
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 0 ? 1.0 : 32
	}

	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return section == 0 ? 1.0 : 32
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BibleSelectionTableViewCell

		// configure the cell
		let selectedSeries = getTraditionalBooksSorted()

		cell.cellText.text = selectedSeries[indexPath.row]

        return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let linkToVisit = biblePassages[indexPath.row]

		let vcTitle = tableView.cellForRow(at: indexPath)?.textLabel?.text

		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-TrTVCL",
			AnalyticsParameterItemName: "SelectedItem-\(vcTitle ?? "index \(indexPath.row)")",
			AnalyticsParameterContentType: "cont"
		])

		tableView.deselectRow(at: indexPath, animated: true)

		if linkToVisit != "" {
			openYouVersionBiblePassage(link: "https://www.bible.com/bible/59/\(linkToVisit).1",
										title: vcTitle)
			//Life.Church appends .esv to the end of the query string automatically
		}
		else {
			print("DEBUG: An error ocurred while trying to load the page. The link was empty.")
		}

	}


}
