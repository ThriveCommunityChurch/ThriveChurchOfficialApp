//
//  SermonDownloadsViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/31/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit
import AVFoundation


class SermonDownloadsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	let downloadsTableView: UITableView = {
		let table = UITableView()
		table.backgroundColor = UIColor.almostBlack
		table.frame = .zero
		table.indicatorStyle = .white
		table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 1))
		table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()
	
	var downloadedMessages = [SermonMessage]()
	var downloadedMessageIds = [String]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.title = "Downloads"
       	setupViews()
		retrieveDownloadsFromStorage()
    }
	
	
	// MARK: - Table View Delegate Methods

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = downloadsTableView.dequeueReusableCell(withIdentifier: "Cell",
												   for: indexPath)
		
		return cell
	}
	
	// MARK: - Methods
	func setupViews() {
		
		downloadsTableView.delegate = self
		downloadsTableView.dataSource = self
	}
	
	func retrieveDownloadsFromStorage() {
		
		// we will be using UserDefaults to store ONLY strings, ints and so on - no Images only links to them
		// this means that when we load the page, we will need to first check if the
		// for each of the sermons in here, if we want to display the graphics, we can use
	}

}
