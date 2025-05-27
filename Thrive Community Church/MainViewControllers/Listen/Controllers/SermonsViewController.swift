//
//  SermonsViewController.swift
//  Thrive Community Church
//
//  Created by Wyatt Baggett on 5/22/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import Firebase
import UIKit
import AVFoundation
import WebKit

class SermonsViewController: UIViewController, AVAudioPlayerDelegate, WKNavigationDelegate, URLSessionDelegate {

    // UI Elements
    let loading: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.backgroundColor = .clear
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let sermonView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        // Do any additional setup after loading the view, typically from a nib.
        sermonView.navigationDelegate = self
        sermonView.loadWebPage(url: "http://thrive-fl.org/teaching-series")
    	self.setLoadingSpinner(spinner: loading)

		// Analytics
		Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
			AnalyticsParameterItemID: "id-SermonWebView",
			AnalyticsParameterItemName: "SermonWebView",
			AnalyticsParameterContentType: "cont"
		])

		// Set the CollectionViewController to be visible from when the application starts
		// A concrete layout object that organizes items into a grid with optional header and footer views for each section.
		let viewLayout = UICollectionViewFlowLayout()
		viewLayout.scrollDirection = .horizontal
		let swipingController = OnboardingController(collectionViewLayout: viewLayout)

		// do not load the view if the user has already completed it
		let completedOB = swipingController.loadAndCheckOnboarding()
		if !completedOB {

			Analytics.logEvent(AnalyticsEventTutorialBegin, parameters: [
				AnalyticsParameterItemID: "id-Onboarding",
				AnalyticsParameterItemName: "Onboarding-init",
				AnalyticsParameterContentType: "cont"
			])

			self.present(swipingController, animated: true, completion: nil)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Setup Views
    func setupViews() {
        view.addSubview(sermonView)
        view.addSubview(loading)

        NSLayoutConstraint.activate([
            sermonView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sermonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sermonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sermonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       loading.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }

}
