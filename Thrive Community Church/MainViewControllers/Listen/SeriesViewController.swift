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
	
	let StartDate: UILabel = {
		let label = UILabel()
		label.textColor = .lightGray
		label.font = UIFont(name: "Avenir-Medium", size: 17)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		formatDataForPresentation(series: series!)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func setupViews() {
		// setup the view itself
		view.backgroundColor = UIColor.bgDarkBlue
		
		// add all the subviews
		view.addSubview(seriesArt)
		view.addSubview(StartDate)
		
		let width = view.frame.width
		let height = (width) * (9 / 16) // 16x9 ratio
		
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				seriesArt.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				seriesArt.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				seriesArt.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				seriesArt.heightAnchor.constraint(equalToConstant: height)
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
	}
	
	func formatDataForPresentation(series: SermonSeries) {
		
		let dateString = series.StartDate
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-ddThh:mm:ss.fffZ"
		dateFormatter.locale = Locale.init(identifier: "en_GB")
		
		let dateObj = dateFormatter.date(from: dateString)
		
		dateFormatter.dateFormat = "MM.dd.yy"
		print("Dateobj: \(dateFormatter.string(from: dateObj!))")
		
	}
}
