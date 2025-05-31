//
//  RSSTableViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 2/24/21.
//  Copyright © 2021 Thrive Community Church. All rights reserved.
//

import UIKit
import FeedKit

class RSSTableViewController: UITableViewController {

	var rssItems: [RSSFeedItem] = [RSSFeedItem]()
	private var reuseIdentifier = "Cell"

	let feedURL = URL(string: "https://us4.campaign-archive.com/feed?u=1c5116a71792ef373ee131ea0&id=e6caee03a4")!

	let loading: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.style = .large
		indicator.color = .white
		indicator.backgroundColor = .clear
		indicator.translatesAutoresizingMaskIntoConstraints = false
		return indicator
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

		navigationItem.title = "Announcements"

		setupViews()

		tableView.backgroundColor = UIColor.almostBlack
		tableView.indicatorStyle = .white
		tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
		tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
		tableView.register(RSSTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

		// Configure and start loading spinner
		self.setLoadingSpinner(spinner: loading)
		loading.startAnimating()

		let parser = FeedParser(URL: feedURL) // or FeedParser(data: data) or FeedParser(xmlStream: stream)

		// Parse asynchronously, not to block the UI.
		parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
			// Do your thing, then back to the Main thread
			DispatchQueue.main.async {
				// Hide loading spinner
				self.loading.stopAnimating()

				// ..and update the UI
				switch result {
				case .success(let feed):
					self.rssItems = feed.rssFeed?.items ?? [RSSFeedItem]()
					self.tableView.reloadData()

				case .failure(let error):
					print("RSS Feed parsing failed: \(error)")
				}
			}
		}
    }

    // MARK: - Setup Views
    func setupViews() {
        // Set the main view background color to ensure visibility
        view.backgroundColor = UIColor.almostBlack

        // For UITableViewController, we need to add the spinner to the table view's superview
        // or create a container view. Let's add it to the table view itself but with proper constraints
        tableView.addSubview(loading)

        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])

        // Bring the loading spinner to front
        tableView.bringSubviewToFront(loading)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return rssItems.count
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! RSSTableViewCell

		let rssItem = rssItems[indexPath.row]

		cell.title.text = rssItem.title

		let dateToStringFormatter = DateFormatter()
		dateToStringFormatter.dateFormat = "MMM d, yyyy"
		dateToStringFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		let dateString = dateToStringFormatter.string(from: rssItem.pubDate ?? Date())

		cell.date.text = dateString

		// make the selection color less intense
		let selectedView = UIView()
		selectedView.backgroundColor = UIColor.darkGray
		cell.selectedBackgroundView = selectedView

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let rssItem = rssItems[indexPath.row]

		let vc = RSSViewController()
		vc.Html = rssItem.content?.contentEncoded ?? ""

		let dateToStringFormatter = DateFormatter()
		dateToStringFormatter.dateFormat = "MMM d, yyyy"
		dateToStringFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		let dateString = dateToStringFormatter.string(from: rssItem.pubDate ?? Date())

		vc.NavHeader = dateString

		self.show(vc, sender: self)

	}

}
