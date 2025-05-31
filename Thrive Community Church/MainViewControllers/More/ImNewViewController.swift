//
//  ImNewViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/16/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class ImNewViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    let loading: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.backgroundColor = .clear
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let imNew: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        imNew.uiDelegate = self
		imNew.navigationDelegate = self

		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.ImNew) as? Data

		var newLink = "http://thrive-fl.org/im-new/"

		if data != nil {

			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: data!) as! ConfigSetting

			newLink = "\(decoded.Value ?? "http://thrive-fl.org/im-new/")"
		}

		let encodedURL = newLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

		let url = URL(string: encodedURL)!
		let request = URLRequest(url: url)
		imNew.load(request)

        self.setLoadingSpinner(spinner: loading)

        // Ensure view background matches to prevent white bars
        view.backgroundColor = UIColor.almostBlack

        // Ensure view fills entire screen
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
    }

    // MARK: - Setup Views
    func setupViews() {
        view.addSubview(imNew)
        view.addSubview(loading)

        NSLayoutConstraint.activate([
            imNew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imNew.bottomAnchor.constraint(equalTo: view.bottomAnchor), // Extend to bottom edge
            imNew.leadingAnchor.constraint(equalTo: view.leadingAnchor), // Extend to edges
            imNew.trailingAnchor.constraint(equalTo: view.trailingAnchor), // Extend to edges
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
