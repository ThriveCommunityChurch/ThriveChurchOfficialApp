//
//  ServeViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 6/21/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import WebKit
import UIKit

class ServeViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var loading: UIActivityIndicatorView!

    let serveWebView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	var serveLink: String = "http://thrive-fl.org/get-involved/"

    override func viewDidLoad() {
        super.viewDidLoad()

        serveWebView.uiDelegate = self
		serveWebView.navigationDelegate = self

		view.insertSubview(serveWebView, at: 0)
		NSLayoutConstraint.activate([
			serveWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			serveWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			serveWebView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			serveWebView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
		])

		let data = UserDefaults.standard.object(forKey: ConfigKeys.shared.Serve) as? Data

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

			self.serveLink = "\(decoded?.Value ?? "http://thrive-fl.org/get-involved/")"
		}

		let encodedURL = self.serveLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

		let url = URL(string: encodedURL)!
		let request = URLRequest(url: url)
		serveWebView.load(request)

        self.setLoadingSpinner(spinner: loading)
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
