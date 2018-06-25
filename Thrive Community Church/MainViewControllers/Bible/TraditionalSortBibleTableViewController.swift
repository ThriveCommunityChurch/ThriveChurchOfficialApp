//
//  TraditionalSortBibleTableViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 6/21/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

class TraditionalSortBibleTableViewController: UITableViewController {

	var biblePassages: [String] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

		biblePassages = self.getUrlforTraditionalBookOrder()
		
		// Always 1 pixel off after the removal
		tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: -1, right: 0)
		
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
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let linkToVisit = biblePassages[indexPath.row]
		
		
		if linkToVisit != "" {
			openVCAtSpecificURL(link: "https://www.bible.com/bible/59/\(linkToVisit).1")
		}
		else {
			print("DEBUG: An error ocurred while trying to load the page. The link was empty.")
		}
		
	}


}