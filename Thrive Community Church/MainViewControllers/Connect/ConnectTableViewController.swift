//
//  ConnectTableViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/22/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import UIKit
import MessageUI

class ConnectTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
	
	var configurations: [Int: DynamicConfigResponse] = [Int: DynamicConfigResponse]()

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
		
		if (config.Setting?.Key == ConfigKeys.shared.AddressMain) {
			let formattedAddress = config.Setting?.Value?.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
			
			self.openUrlAnyways(link: "http://maps.apple.com/?daddr=\(formattedAddress ?? ""))&dirflg=d")
		}
		else if (config.Setting == nil) {
			self.present(config.Destination, animated: true, completion: nil)
		}
		else {
			self.show(config.Destination, sender: self)
		}
	}
	
	// MARK: - Methods
	
	func loadConfigs() -> [Int: DynamicConfigResponse] {
		
		var tempList: [DynamicConfigResponse] = [DynamicConfigResponse]()

		// load all the configs so we can count how many we have to present
		let addressData = UserDefaults.standard.object(forKey: ConfigKeys.shared.AddressMain) as? Data
		
		let serveData = UserDefaults.standard.object(forKey: ConfigKeys.shared.Serve) as? Data
		let smallGroupData = UserDefaults.standard.object(forKey: ConfigKeys.shared.SmallGroup) as? Data
		
		// AT LEAST ONE of the following must be present in order for us to display "Contact Us"
		let emailData = UserDefaults.standard.object(forKey: ConfigKeys.shared.EmailMain) as? Data
		let phoneData = UserDefaults.standard.object(forKey: ConfigKeys.shared.PhoneMain) as? Data
		let prayersData = UserDefaults.standard.object(forKey: ConfigKeys.shared.Prayers) as? Data
		
		
		if (emailData != nil || phoneData != nil || prayersData != nil) {
			
			let vc = UIAlertController(title: "Contact us",
									   message: "Please select an option",
									   preferredStyle: .actionSheet)
						
			if (emailData != nil) {
				
				var email: String = "info@thrive-fl.org"
				
				// reading from the messageId collection in UD
				let decoded = NSKeyedUnarchiver.unarchiveObject(with: emailData!) as! ConfigSetting
				
				email = "\(decoded.Value ?? "info@thrive-fl.org")"
				
				vc.addAction(UIAlertAction(title: "Email us", style: .default, handler: { (action) in
					
					if MFMailComposeViewController.canSendMail() {
						
						let composeVC = MFMailComposeViewController()
						composeVC.mailComposeDelegate = self
						composeVC.setToRecipients([email])
						self.present(composeVC, animated: true, completion: nil)
					}
					else {
						self.displayAlertForAction()
					}
					
				}))
			}
			
			if (phoneData != nil) {
				
				vc.addAction(UIAlertAction(title: "Call us", style: .default, handler: { (action) in
					
					// reading from the messageId collection in UD
					let decoded = NSKeyedUnarchiver.unarchiveObject(with: phoneData!) as! ConfigSetting
					
					if let url = URL(string: "tel://\(decoded.Value ?? "2396873430")") {
						
						if UIApplication.shared.canOpenURL(url) {
							UIApplication.shared.open(url, options: [:], completionHandler: nil)
							print("Calling")
						}
						else {
							self.displayAlertForAction()
						}
					}
				}))
			}
			
			if (prayersData != nil) {
				
				vc.addAction(UIAlertAction(title: "Submit a prayer request", style: .default, handler: { (action) in
					
					// reading from the messageId collection in UD
					let prayerDecoded = NSKeyedUnarchiver.unarchiveObject(with: prayersData!) as! ConfigSetting
					
					let prayerVC = GenericSiteViewController()
					prayerVC.link = prayerDecoded.Value!
					prayerVC.navHeader = "Prayer request"
					
					self.show(prayerVC, sender: self)
				}))
			}
			
			vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			
			let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: vc,
																				 setting: nil,
																				 title: "Contact us")
			tempList.append(settingToAdd)
		}
		
		if addressData != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: addressData!) as! ConfigSetting
			
			let nowhere = UIViewController()
			
			let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: nowhere,
																				 setting: decoded,
																				 title: "Get directions")
			
			tempList.append(settingToAdd)
		}
		
		if smallGroupData != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: smallGroupData!) as! ConfigSetting
			
			let groupsVC = GenericSiteViewController()
			groupsVC.link = decoded.Value!
			groupsVC.navHeader = "Join a small group"
			
			let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: groupsVC,
																				 setting: decoded,
																				 title: "Join a Small Group")
			
			tempList.append(settingToAdd)
		}
		
		if serveData != nil {
			
			// reading from the messageId collection in UD
			let decoded = NSKeyedUnarchiver.unarchiveObject(with: serveData!) as! ConfigSetting
			
			let groupsVC = GenericSiteViewController()
			groupsVC.link = decoded.Value!
			groupsVC.navHeader = "Serve"
			
			let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: groupsVC,
																				 setting: decoded,
																				 title: "Serve")
			
			tempList.append(settingToAdd)
		}
		
		var response: [Int: DynamicConfigResponse] = [Int: DynamicConfigResponse]()
		
		var count = 0
		for config in tempList {
			
			response[count] = config
			
			count += 1
		}
		
		return response
	}
	
    // Standard Mail compose controller code
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
            
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
            
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
            
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
            
        default:
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}
