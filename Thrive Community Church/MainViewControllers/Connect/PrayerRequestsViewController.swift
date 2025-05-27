//
//  PrayerRequestsViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/20/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class PrayerRequestsViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    let loading: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.backgroundColor = .clear
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let prayerRequestsView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        prayerRequestsView.uiDelegate = self
		prayerRequestsView.navigationDelegate = self

		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.Prayers) as? Data

		var prayerLink = "http://thrive-fl.org/prayer-requests"

		if data != nil {

			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: data!) as! ConfigSetting

			prayerLink = "\(decoded.Value ?? "http://thrive-fl.org/prayer-requests")"
		}

		let encodedURL = prayerLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

		let url = URL(string: encodedURL)!
		let request = URLRequest(url: url)
		prayerRequestsView.load(request)

        self.setLoadingSpinner(spinner: loading)
    }

    // MARK: - Setup Views
    func setupViews() {
        view.addSubview(prayerRequestsView)
        view.addSubview(loading)

        NSLayoutConstraint.activate([
            prayerRequestsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            prayerRequestsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            prayerRequestsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            prayerRequestsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		loading.stopAnimating()
	}

	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		loading.startAnimating()
	}

}
