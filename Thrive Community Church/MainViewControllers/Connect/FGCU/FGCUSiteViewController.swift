//
//  FGCUSiteViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit
import WebKit

class FGCUSiteViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    let loading: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.backgroundColor = .clear
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

	let FGCUWebView: WKWebView = {
		let view = WKWebView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

		FGCUWebView.uiDelegate = self
		FGCUWebView.navigationDelegate = self

		let url = URL(string: "http://thrive-fl.org/youth/college/")!
		let request = URLRequest(url: url)
		FGCUWebView.load(request)

        self.setLoadingSpinner(spinner: loading)
    }

    // MARK: - Setup Views
    func setupViews() {
        view.addSubview(FGCUWebView)
        view.addSubview(loading)

        NSLayoutConstraint.activate([
            FGCUWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            FGCUWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            FGCUWebView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            FGCUWebView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
