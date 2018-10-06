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

class SermonsViewController: UIViewController, AVAudioPlayerDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var sermonView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        // Do any additional setup after loading the view, typically from a nib.
        sermonView.delegate = self
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
		
		// TODO: add observers or something like that for AVSession events and
		// if someone tries to play video during an audio playback, pause the
		// audio in favor of the video
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
       loading.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loading.stopAnimating()
    }
	
}
