//
//  ViewPlayerViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 12/24/19.
//  Copyright © 2019 Thrive Community Church. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit

public class ViewPlayerViewController: UIViewController, WKNavigationDelegate {
	
	// MARK: - Init
	public var VideoId: String = "" {
		didSet {
			self.videoId = VideoId
		}
	}
	
	public var Message: SermonMessage! {
		didSet {
			self.message = Message
		}
	}
	
	fileprivate var videoId: String = ""
	fileprivate var message: SermonMessage!

		
	// MARK: - UI Elements
	let videoBG: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let userImg: UIImageView = {
		let view = UIImageView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		view.image = UIImage.init(named: "user")
		return view
	}()
	
	let speakerText: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Book", size: 17)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let calendarImg: UIImageView = {
		let view = UIImageView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		view.image = UIImage.init(named: "calendar")
		return view
	}()
	
	let dateText: UILabel = {
		let label = UILabel()
		label.textAlignment = .left
		label.font = UIFont(name: "Avenir-Book", size: 17)
		label.textColor = .lightGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let spinner:  UIActivityIndicatorView = {
		let view = UIActivityIndicatorView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let progressView:  UIProgressView = {
		let view = UIProgressView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.tintColor = .mainBlue
		view.backgroundColor = .darkGray
		return view
	}()
	
	var webView: WKWebView = WKWebView()

	override public func viewDidLoad() {
        super.viewDidLoad()
		
		
		self.setupViews()
		DispatchQueue.main.async {
			self.loadMetadata()
		}
    }
    
	override public func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func setupViews() {
		
		view.backgroundColor = .bgDarkBlue
		
		let openYTButton = UIBarButtonItem(title: "",
										   style: .plain,
										   target: self,
										   action: #selector(watchOnYT))
		openYTButton.image = UIImage(named: "youtube")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
		self.navigationItem.rightBarButtonItem = openYTButton
		
		// add all the subviews
		view.addSubview(videoBG)
		view.addSubview(userImg)
		view.addSubview(speakerText)
		view.addSubview(calendarImg)
		view.addSubview(dateText)
		
		let width = view.frame.width
		let height = (width) * (9 / 16) // 16x9 ratio
		
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				videoBG.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				videoBG.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				videoBG.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				videoBG.heightAnchor.constraint(equalToConstant: height),
				userImg.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
				userImg.topAnchor.constraint(equalTo: videoBG.bottomAnchor, constant: 24),
				userImg.heightAnchor.constraint(equalToConstant: 18),
				userImg.widthAnchor.constraint(equalToConstant: 18),
				speakerText.leadingAnchor.constraint(equalTo: userImg.trailingAnchor, constant: 10),
				speakerText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
													constant: -24),
				speakerText.centerYAnchor.constraint(equalTo: userImg.centerYAnchor),
				speakerText.bottomAnchor.constraint(equalTo: userImg.bottomAnchor),
				calendarImg.leadingAnchor.constraint(equalTo: userImg.leadingAnchor),
				calendarImg.heightAnchor.constraint(equalTo: userImg.heightAnchor),
				calendarImg.widthAnchor.constraint(equalTo: userImg.widthAnchor),
				calendarImg.topAnchor.constraint(equalTo: userImg.bottomAnchor, constant: 14),
				dateText.leadingAnchor.constraint(equalTo: speakerText.leadingAnchor),
				dateText.trailingAnchor.constraint(equalTo: speakerText.trailingAnchor),
				dateText.heightAnchor.constraint(equalTo: speakerText.heightAnchor),
				dateText.centerYAnchor.constraint(equalTo: calendarImg.centerYAnchor)
			])	
		}
		else {
			NSLayoutConstraint.activate([
				videoBG.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				videoBG.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				videoBG.topAnchor.constraint(equalTo: view.topAnchor),
				videoBG.heightAnchor.constraint(equalToConstant: height)
			])
		}
		
		self.setSpinner(spinner: spinner)
		self.spinner.startAnimating()
		view.addSubview(spinner)
		
		view.addSubview(progressView)
		progressView.isHidden = true
		
		// spinner & progress bar
		NSLayoutConstraint.activate([
			spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			spinner.centerYAnchor.constraint(equalTo: videoBG.centerYAnchor),
			spinner.heightAnchor.constraint(equalToConstant: 25),
			spinner.widthAnchor.constraint(equalToConstant: 25),
			progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			progressView.bottomAnchor.constraint(equalTo: videoBG.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
		])
		
		self.loadYoutube(videoID: self.videoId)
	}
	
	@objc func watchOnYT() {
		
		// Open in YT app?
		
		// if youtube is installed open it there, otherwise just open the
		let urlString = "youtube://\(videoId)"
						
		var url = URL(string: urlString)!
		if !UIApplication.shared.canOpenURL(url)  {
			url = URL(string:"http://www.youtube.com/watch?v=\(videoId)")!
			UIApplication.shared.open(url)
		}
		else {
			UIApplication.shared.open(url)
		}
	}
	
	func loadYoutube(videoID: String) {
		
		let configuration = WKWebViewConfiguration()
		configuration.allowsInlineMediaPlayback = true
		
		let width = view.frame.width
		let height = (width) * (9 / 16) // 16x9 ratio
		
		let headerHeight = UIApplication.shared.statusBarFrame.height +
		self.navigationController!.navigationBar.frame.height
		
        if let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1") {
			
			webView = WKWebView(frame:
				CGRect(x: 0, y: headerHeight,
						   width: width,
						   height: height),
					configuration: configuration)
						
			webView.navigationDelegate = self
			
			webView.layer.backgroundColor = UIColor.black.cgColor
			webView.isOpaque = false
			
			progressView.isHidden = false
			webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
								options: .new,
								context: nil)
			
			webView.load( URLRequest(url: youtubeURL) )
			
			view.insertSubview(webView, belowSubview: spinner)
		}
    }
	
	func loadMetadata() {
		self.speakerText.text = self.message.Speaker
		self.dateText.text = self.message.Date
	}
	
	public func webView(_ webView: WKWebView,
					 didFinish navigation: WKNavigation!){

		webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
		
		self.spinner.stopAnimating()
		
		self.fadeOut()
	}
	
	private func fadeOut() {
		
		UIView.animate(withDuration: 0.55,
                       animations: {
                           self.progressView.alpha = 0.0
                       },
                       completion: { isFinished in
                           // Update `isHidden` flag accordingly:
                           //  - set to `true` in case animation was completly finished.
                           //  - set to `false` in case animation was interrupted, e.g. due to starting of another animation.
                           self.progressView.isHidden = isFinished
        })
		
	}
	
	override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
	}
	
	func setSpinner(spinner: UIActivityIndicatorView) {
		
		spinner.style = .whiteLarge
		spinner.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255,
										  alpha: 0.60)
		spinner.color = .white
	}
	
}
