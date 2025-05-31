//
//  SmallGroupViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/24/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class SmallGroupViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    let loading: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.backgroundColor = .clear
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let smallGroup: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        smallGroup.uiDelegate = self
		smallGroup.navigationDelegate = self

		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.SmallGroup) as? Data

		var groupsLink = "http://thrive-fl.org/join-small-group"

		if data != nil {

			// reading from the messageId collection in UD
            var decoded: ConfigSetting? = nil

            // Use secure coding with explicit allowed classes
            let allowedClasses = NSSet(array: [
                ConfigSetting.self,
                NSString.self,
                NSNumber.self,
                NSData.self,
                NSDate.self
            ])

            do {
                decoded = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses as! Set<AnyHashable>, from: data!) as? ConfigSetting
            } catch {
                decoded = nil
            }

			groupsLink = "\(decoded?.Value ?? "http://thrive-fl.org/join-small-group")"
		}

		let encodedURL = groupsLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

		let url = URL(string: encodedURL)!
		let request = URLRequest(url: url)
		smallGroup.load(request)

        self.setLoadingSpinner(spinner: loading)
    }

    // MARK: - Setup Views
    func setupViews() {
        view.addSubview(smallGroup)
        view.addSubview(loading)

        NSLayoutConstraint.activate([
            smallGroup.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            smallGroup.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            smallGroup.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            smallGroup.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
