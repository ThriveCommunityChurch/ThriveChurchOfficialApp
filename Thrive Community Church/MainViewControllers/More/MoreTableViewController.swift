//
//  MoreTableViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/29/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController  {
	
	var configurations: [Int: DynamicConfigResponse] = [Int: DynamicConfigResponse]()
	let alertTitle = "Alert"
	let cancel = "Cancel"
	let downloadTitle = "Download"

    override func viewDidLoad() {
        super.viewDidLoad()

		self.configurations = self.loadConfigs()

    }

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return configurations.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

		let config = configurations[indexPath.row]
		
		if (config != nil) {
			cell.textLabel?.text = config?.CellTitle
		}
		
		cell.textLabel?.textColor = .white
		cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 17)
		cell.accessoryType = .disclosureIndicator

		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let config = configurations[indexPath.row]!
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		if (config.CellTitle == "Social") {
			self.present(config.Destination, animated: true, completion: nil)
		}
		else if (config.Setting?.Key == ConfigKeys.shared.Give) {
			self.openUrlAnyways(link: config.Setting?.Value ?? "")
		}
		else if (config.CellTitle == "About") {
			self.performSegue(withIdentifier: "about", sender: self)
		}
		else if (config.CellTitle == "Settings") {
			self.performSegue(withIdentifier: "settings", sender: self)
		}
		else {
			self.show(config.Destination, sender: self)
		}
	}
	
	// MARK: - Methods
	
	func loadConfigs() -> [Int: DynamicConfigResponse] {
		
		var tempList: [DynamicConfigResponse] = [DynamicConfigResponse]()

		// load all the configs so we can count how many we have to present
		let imNewData = UserDefaults.standard.object(forKey: ConfigKeys.shared.ImNew) as? Data
		let giveData = UserDefaults.standard.object(forKey: ConfigKeys.shared.Give) as? Data
		let teamData = UserDefaults.standard.object(forKey: ConfigKeys.shared.Team) as? Data
		
		// AT LEAST ONE of the following must be present in order for us to display "Social"
		let fbData = UserDefaults.standard.object(forKey: ConfigKeys.shared.FB_Social) as? Data
		let igData = UserDefaults.standard.object(forKey: ConfigKeys.shared.IG_Social) as? Data
		let twData = UserDefaults.standard.object(forKey: ConfigKeys.shared.TW_Social) as? Data
		let fbPageData = UserDefaults.standard.object(forKey: ConfigKeys.shared.FBPageID) as? Data
		let igUsernameData = UserDefaults.standard.object(forKey: ConfigKeys.shared.IGUSername) as? Data
		let twUsernameData = UserDefaults.standard.object(forKey: ConfigKeys.shared.TWUsername) as? Data
		
		if imNewData != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: imNewData!) as! ConfigSetting
			
			let newVC = GenericSiteViewController()
			newVC.link = decoded.Value!
			newVC.navHeader = "I'm New"
			
			let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: newVC,
																				 setting: decoded,
																				 title: "I'm New")
			
			tempList.append(settingToAdd)
		}
		
		if giveData != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: giveData!) as! ConfigSetting
			
			let nowhere = UIViewController()
			
			let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: nowhere,
																				 setting: decoded,
																				 title: "Give")
			
			tempList.append(settingToAdd)
		}
		
		if (fbData != nil || fbPageData != nil || igData != nil || igUsernameData != nil ||
				twData != nil || twUsernameData != nil) {
			
			let vc = UIAlertController(title: "Social",
									   message: "Please select an option",
									   preferredStyle: .actionSheet)
						
			if (fbPageData != nil) {
								
				vc.addAction(UIAlertAction(title: "Facebook", style: .default, handler: { (action) in
					
					let decoded = NSKeyedUnarchiver.unarchiveObject(with: fbPageData!) as! ConfigSetting
					
					let fbId = "\(decoded.Value ?? "157139164480128")"
					
					let appURL = URL(string: "fb://profile/\(fbId)")!
					print(appURL.absoluteString)
					
					if UIApplication.shared.canOpenURL(appURL) {
						UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
					}
					else {
						let message = "You need to download the Facebook app first"
						let alert = UIAlertController(title: self.alertTitle,
											 message: message,
											 preferredStyle: UIAlertController.Style.alert)
						let cancelButton = UIAlertAction(title: self.cancel,
											 style: UIAlertAction.Style.destructive,
											 handler: nil)
						let downloadFacebook = UIAlertAction(title: self.downloadTitle,
											 style: UIAlertAction.Style.default,
												 handler: { (action) -> Void in
							
							if let link = URL(string: "itms-apps://itunes.apple.com/app/id284882215"),
								UIApplication.shared.canOpenURL(link) {
								UIApplication.shared.open(link, options: [:], completionHandler: nil)
							}
						})
						alert.addAction(cancelButton)
						alert.addAction(downloadFacebook)
						
						self.present(alert, animated: true, completion: nil)
					}
				}))
				
			}
			else if (fbData != nil) {
				
				vc.addAction(UIAlertAction(title: "Facebook", style: .default, handler: { (action) in
					
					let decoded = NSKeyedUnarchiver.unarchiveObject(with: fbData!) as! ConfigSetting
					
					let fbURL = URL(string: "\(decoded.Value ?? "")")!
					print(fbURL.absoluteString)
					
					if UIApplication.shared.canOpenURL(fbURL) {
						UIApplication.shared.open(fbURL, options: [:], completionHandler: nil)
					}
					else {
						self.displayAlertForAction()
					}
				}))
				
			}
			
			if (igUsernameData != nil) {
				
				vc.addAction(UIAlertAction(title: "Instagram", style: .default, handler: { (action) in
					
					let decoded = NSKeyedUnarchiver.unarchiveObject(with: igUsernameData!) as! ConfigSetting
					
					let igUsername = "\(decoded.Value ?? "thrive_fl")"

					let appURL = URL(string: "instagram://user?username=\(igUsername)")!
					print(appURL.absoluteString)
					
					if UIApplication.shared.canOpenURL(appURL) {
						UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
					}
					else {
						let message = "You need to download the Instagram app first"
						let alert = UIAlertController(title: self.alertTitle,
											  message: message,
											  preferredStyle: UIAlertController.Style.alert)
						let cancelButton = UIAlertAction(title: self.cancel,
														 style: UIAlertAction.Style.destructive,
											  handler: nil)
						let downloadInstagram = UIAlertAction(title: self.downloadTitle,
															  style: UIAlertAction.Style.default,
												  handler: { (action) -> Void in
							
							if let link = URL(string: "itms-apps://itunes.apple.com/app/id389801252"),
								UIApplication.shared.canOpenURL(link) {
								UIApplication.shared.open(link, options: [:], completionHandler: nil)
							}
						})
						alert.addAction(cancelButton)
						alert.addAction(downloadInstagram)
						
						self.present(alert, animated: true, completion: nil)
					}
				}))
				
			}
			else if (igData != nil) {
				
				vc.addAction(UIAlertAction(title: "Instagram", style: .default, handler: { (action) in
					
					let decoded = NSKeyedUnarchiver.unarchiveObject(with: igData!) as! ConfigSetting
					
					let igURL = URL(string: "\(decoded.Value ?? "")")!
					print(igURL.absoluteString)
					
					if UIApplication.shared.canOpenURL(igURL) {
						UIApplication.shared.open(igURL, options: [:], completionHandler: nil)
					}
					else {
						self.displayAlertForAction()
					}
				}))
				
			}
			
			if (twUsernameData != nil) {
				
				vc.addAction(UIAlertAction(title: "Twitter", style: .default, handler: { (action) in
					
					let decoded = NSKeyedUnarchiver.unarchiveObject(with: twUsernameData!) as! ConfigSetting
					
					let twUsername = "\(decoded.Value ?? "Thrive_FL")"

					let appURL = URL(string: "twitter:///user?screen_name=\(twUsername)")!
					print(appURL.absoluteString)
					
					if UIApplication.shared.canOpenURL(appURL) {
						UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
					}
					else {
						let message = "You need to download the Twitter app first"
						let alert = UIAlertController(title: self.alertTitle,
											  message: message,
											  preferredStyle: UIAlertController.Style.alert)
						let cancelButton = UIAlertAction(title: self.cancel,
														 style: UIAlertAction.Style.destructive,
											  handler: nil)
						let downloadTwitter = UIAlertAction(title: self.downloadTitle,
											  style: UIAlertAction.Style.default,
												  handler: { (action) -> Void in
							
							if let link = URL(string: "itms-apps://itunes.apple.com/app/id409789998"),
								UIApplication.shared.canOpenURL(link) {
								UIApplication.shared.open(link, options: [:], completionHandler: nil)
							}
						})
						alert.addAction(cancelButton)
						alert.addAction(downloadTwitter)
						
						self.present(alert, animated: true, completion: nil)
					}
				}))
				
			}
			else if (twData != nil) {
				
				vc.addAction(UIAlertAction(title: "Twitter", style: .default, handler: { (action) in
					
					let decoded = NSKeyedUnarchiver.unarchiveObject(with: twData!) as! ConfigSetting
					
					let twURL = URL(string: "\(decoded.Value ?? "")")!
					print(twURL.absoluteString)
					
					if UIApplication.shared.canOpenURL(twURL) {
						UIApplication.shared.open(twURL, options: [:], completionHandler: nil)
					}
					else {
						self.displayAlertForAction()
					}
				}))
				
			}
			
			vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			
			let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: vc,
																				 setting: nil,
																				 title: "Social")
			tempList.append(settingToAdd)
		}
		
		if teamData != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: teamData!) as! ConfigSetting
			
			let teamVC = GenericSiteViewController()
			teamVC.link = decoded.Value!
			teamVC.navHeader = "Meet the team"
			
			let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: teamVC,
																				 setting: decoded,
																				 title: "Meet the team")
			
			tempList.append(settingToAdd)
		}
		
		let nowhere = UIViewController()
		
		let settingsOption: DynamicConfigResponse = DynamicConfigResponse.init(destination: nowhere,
																			 setting: nil,
																			 title: "Settings")
		tempList.append(settingsOption)
		
		let aboutOption: DynamicConfigResponse = DynamicConfigResponse.init(destination: nowhere,
																			 setting: nil,
																			 title: "About")
		tempList.append(aboutOption)
		
		var response: [Int: DynamicConfigResponse] = [Int: DynamicConfigResponse]()
		
		var count = 0
		for config in tempList {
			
			response[count] = config
			
			count += 1
		}
		
		return response
	}

}
