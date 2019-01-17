//
//  RecentlyPlayedViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 1/16/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit

class RecentlyPlayedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	// UI Elements
	let recentlyPlayedTable: UITableView = {
		let table = UITableView()
		table.frame = .zero
		table.indicatorStyle = .white
		table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 1))
		table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()
	
	let spinner: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.activityIndicatorViewStyle = .whiteLarge
		indicator.color = .white
		indicator.backgroundColor = .clear
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()
	
	// Variables
	var messages = [SermonMessage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Table View info
		recentlyPlayedTable.delegate = self
		recentlyPlayedTable.dataSource = self
		
		self.recentlyPlayedTable.register(RecentlyWatchedTableViewCell.self, forCellReuseIdentifier: "Cell")
		
		setupViews()
		
		// do this in the background because there's a lot of data here if the array is full
		DispatchQueue.main.async {
			self.retrieveRecentlyPlayed()
		}
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// Mark: - TableView
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = recentlyPlayedTable.dequeueReusableCell(withIdentifier: "Cell",
												   for: indexPath) as! RecentlyWatchedTableViewCell
		
		let message = messages[indexPath.row]
		cell.date.text = message.Date
		cell.seriesArt.image = message.seriesArt?.uiImage
		cell.title.text = message.Title
		cell.passageRef.text = message.PassageRef
		cell.speaker.text = message.Speaker
		
		// make the selection color less intense
		let selectedView = UIView()
		selectedView.backgroundColor = UIColor.darkGray
		cell.selectedBackgroundView = selectedView
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let message = messages[indexPath.row]
		
		recentlyPlayedTable.deselectRow(indexPath: indexPath)
		
		print(message)
	}
		
	// MARK: - Methods
	func setupViews() {
		
		view.layer.backgroundColor = UIColor.almostBlack.cgColor
		
		// add subviews
		view.addSubview(recentlyPlayedTable)
		view.addSubview(spinner)

		// constraints
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				recentlyPlayedTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				recentlyPlayedTable.topAnchor.constraint(equalTo: view.topAnchor),
				recentlyPlayedTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				recentlyPlayedTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
			])
		} else {
			// Fallback on earlier versions
			NSLayoutConstraint.activate([
				recentlyPlayedTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				recentlyPlayedTable.topAnchor.constraint(equalTo: view.topAnchor),
				recentlyPlayedTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				recentlyPlayedTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
				spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
			])
		}
		
		// apparently declaring this above doesn't want to work
		self.recentlyPlayedTable.backgroundColor = UIColor.almostBlack
		self.spinner.startAnimating()
	}
	
	func retrieveRecentlyPlayed() {
		
		// reading from the messageId collection in UD
		let decoded = UserDefaults.standard.object(forKey: ApplicationVariables.RecentlyPlayed) as? Data
		if decoded != nil {
			
			let decodedSermonMessages = NSKeyedUnarchiver.unarchiveObject(with: decoded ?? Data()) as! [SermonMessage]

			// get the recently played sermon messages
			self.messages = decodedSermonMessages
			
			self.recentlyPlayedTable.reloadData()
		}
		
		self.spinner.stopAnimating()
	}
}
