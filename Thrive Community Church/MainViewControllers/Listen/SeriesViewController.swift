//
//  SeriesViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/28/18.
//  Copyright © 2018 Thrive Community Church. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController {
	
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
		}
	}
	
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
		label.font = UIFont(name: "Avenir-Medium", size: 16)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let passageRef: UILabel = {
		let label = UILabel()
		label.textColor = .lightGray
		label.font = UIFont(name: "Avenir-BookOblique", size: 13)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		
		// TODO: ADD A LINK TO THE WEBSITE EITHER AT THE TOP RIGHT OR
		// BELOW THE ART FOR THE SERIES, THAT MIGHT LOOK / FEEL NICE TO HAVE
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
		view.addSubview(passageRef)
		
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
				passageRef.topAnchor.constraint(equalTo: seriesArt.bottomAnchor, constant: 16),
				passageRef.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
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
//		passageRef.text = series
	}
	
	func formatDataForPresentation(series: SermonSeries) -> SermonSeries{
		
		var response = series
		let dateValue = series.StartDate
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: dateValue)
		
		let dateToStringFormatter = DateFormatter()
		dateToStringFormatter.dateFormat = "M.d.yy"
		let dateString = dateToStringFormatter.string(from: date!)
		
		response.StartDate = dateString
		
		return response
	}
}
