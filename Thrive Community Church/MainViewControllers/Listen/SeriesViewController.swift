//
//  SeriesViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	// MARK: - Setters
	// public setters that need to be init before we can transition
	public var seriesImage = UIImage() {
		didSet {
			self.seriesArt.image = seriesImage
		}
	}
	
	public var SermonSeries: SermonSeries? {
		didSet {
			self.title = SermonSeries?.Name
			series = SermonSeries
			weekNum = series?.Messages.count ?? 0
		}
	}
	
	var messages = [SermonMessage]()
	var weekNum: Int = 0
	
	private var series: SermonSeries?
	
	// MARK: - UI Elements
	let seriesArt: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	
	let startDate: UILabel = {
		let label = UILabel()
		label.textColor = .lightGray
		label.font = UIFont(name: "Avenir-Book", size: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let seriesTable: UITableView = {
		let table = UITableView()
		table.backgroundColor = UIColor.almostBlack
		table.frame = .zero
		table.indicatorStyle = .white
		table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: 1))
		table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		table.translatesAutoresizingMaskIntoConstraints = false
		return table
	}()
	
	// MARK: - Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		seriesTable.delegate = self
		seriesTable.dataSource = self
		
		self.seriesTable.register(SermonMessageTableViewCell.self, forCellReuseIdentifier: "Cell")
		
		setupViews()
		loadMessagesForSeries()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func setupViews() {
		// setup the view itself
		view.backgroundColor = UIColor.bgDarkBlue
		
		// add all the subviews
		view.addSubview(seriesArt)
		view.addSubview(startDate)
		view.addSubview(seriesTable)
		
		let width = view.frame.width
		let height = (width) * (9 / 16) // 16x9 ratio
		
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				seriesArt.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				seriesArt.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				seriesArt.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				seriesArt.heightAnchor.constraint(equalToConstant: height),
				startDate.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
				startDate.topAnchor.constraint(equalTo: seriesArt.bottomAnchor, constant: 16),
				seriesTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				seriesTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				seriesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				seriesTable.topAnchor.constraint(equalTo: startDate.bottomAnchor, constant: 16)
			])
		}
		else {
			// Fallback on earlier versions
			NSLayoutConstraint.activate([
				seriesArt.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				seriesArt.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				seriesArt.topAnchor.constraint(equalTo: view.topAnchor),
				seriesArt.heightAnchor.constraint(equalToConstant: height)
			])
		}
		
		let updatedSeriesInfo = formatDataForPresentation(series: series!)
		
		// set the properties
		if series?.StartDate != nil && series?.EndDate == nil {
			startDate.text = "Current Series"
		}
		else {
			// set the updated information
			startDate.text = "Started: \(updatedSeriesInfo.StartDate)"
		}
		
		// the passage refs will come from each message, which might look nice in
		// a TableViewController at the bottom?
	}
	
	func formatDataForPresentation(series: SermonSeries) -> SermonSeries{
		
		var response = series
		
		// format dates
		response.StartDate = series.StartDate.FormatDateFromISO8601ForUI()
		
		return response
	}
	
	func loadMessagesForSeries() {
		
		for var i in (series?.Messages)! {
			i.WeekNum = weekNum
			weekNum = weekNum - 1
			
			let date = i.Date.FormatDateFromISO8601ForUI()
			i.Date = date
			
			messages.append(i)
		}
		
		seriesTable.reloadData()
	}
	
	// MARK: - Table View
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = seriesTable.dequeueReusableCell(withIdentifier: "Cell",
												   for: indexPath) as! SermonMessageTableViewCell
		
		let selectedMessage = messages[indexPath.row]
		
		cell.title.text = selectedMessage.Title
		cell.weekNum.text = "\(selectedMessage.WeekNum ?? 0)"
		cell.date.text = selectedMessage.Date
		cell.speaker.text = selectedMessage.Speaker
		cell.passageRef.text = selectedMessage.PassageRef
		
		if selectedMessage.AudioUrl == nil {
			cell.listenImage.isHidden = true
		}
		else {
			cell.listenImage.isHidden = false
		}
		
		if selectedMessage.VideoUrl == nil {
			cell.watchImage.isHidden = true
		}
		else {
			cell.watchImage.isHidden = false
		}
		
		let selectedView = UIView()
		selectedView.backgroundColor = UIColor.darkGray
		cell.selectedBackgroundView = selectedView
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let selectedMessage = messages[indexPath.row]
		
		let alert = UIAlertController(title: "\(series?.Name ?? "") - Week \(selectedMessage.WeekNum ?? 0)",
									  message: "Please select an action",
									  preferredStyle: .actionSheet)
		var listenAction: UIAlertAction
		var watchAction: UIAlertAction
		
		// these ifs both will prevent the Alert Actions from appearing if the message
		// does not have this property set
		if selectedMessage.AudioUrl != nil {
			
			listenAction = UIAlertAction(title: "Listen", style: .default) { (action) in
				
				self.deselectRow(indexPath: indexPath)
				alert.dismiss(animated: true, completion: nil)
			}
			
			alert.addAction(listenAction)
		}
		
		if selectedMessage.AudioUrl != nil {
			
			watchAction = UIAlertAction(title: "Watch in HD", style: .default) { (action) in
				
				self.deselectRow(indexPath: indexPath)
				alert.dismiss(animated: true, completion: nil)
			}
			
			alert.addAction(watchAction)
		}
		
		let readPassageAction = UIAlertAction(title: "Read \(selectedMessage.PassageRef ?? "")",
											  style: .default) { (action) in
			
			self.deselectRow(indexPath: indexPath)
			alert.dismiss(animated: true, completion: nil)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			
			self.deselectRow(indexPath: indexPath)
			alert.dismiss(animated: true, completion: nil)
		}
	
		alert.addAction(readPassageAction)
		alert.addAction(cancelAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	private func deselectRow(indexPath: IndexPath) {
		// Change the selected background view of the cell back to unselected
		seriesTable.deselectRow(at: indexPath, animated: true)
	}
}
