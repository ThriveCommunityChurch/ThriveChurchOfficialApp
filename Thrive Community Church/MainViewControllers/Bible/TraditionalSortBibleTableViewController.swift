//
//  TraditionalSortBibleTableViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 6/21/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

class TraditionalSortBibleTableViewController: UITableViewController {
	
	let biblePassages = [BiblePassage]()

    override func viewDidLoad() {
        super.viewDidLoad()

		
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
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let linkToVisit = biblePassages[indexPath.row].url
		
		openVCAtSpecificURL(link: linkToVisit)
	}


}
