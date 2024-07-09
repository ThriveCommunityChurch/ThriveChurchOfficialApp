//
//  MoreTableViewController.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 8/29/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import UIKit
import MessageUI

class MoreTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
	
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
            let year = Calendar.current.component(.year, from: Date())
            
            let alert = UIAlertController(title: "App Version",
                                          message: "\(self.version())\n\n©\(year) Thrive Community Church",
                                          preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Send Logs", style: .default, handler: { action in
                // lets not create a fild on the user's device if they can't even send us an email
                if MFMailComposeViewController.canSendMail() {
                
                    // vars to add to the file
                    let buildNum = self.build()
                    let uuid = UUID().uuidString.suffix(8)
                    let date = self.getDate()
                    
                    // Save data to file
                    let fileName = "\(uuid).log"
                    let documentDirURL = try! FileManager.default.url(for: .documentDirectory,
                                                                      in: .userDomainMask,
                                                                      appropriateFor: nil,
                                                                      create: true)
                    
                    let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
                    
                    var systemInfo = utsname()
                    uname(&systemInfo)
                    
                    let identifier = Mirror(reflecting: systemInfo.machine).children.reduce("") { identifier, element in
                        guard let value = element.value as? Int8, value != 0 else { return identifier }
                        return identifier + String(UnicodeScalar(UInt8(value)))
                    }
                    
                    let writeString = "PLEASE DO NOT MODIFY THE CONTENTS OF THIS FILE\n" +
                        "\n©\(year) Thrive Community Church. All information collected is used solely for product development and is never sold.\n" +
                        "\n\nDevice Information" +
                        "\nIdentifier: \(identifier)" +
                        "\nLocalizedModel: \(UIDevice.current.localizedModel)" +
                        "\nDeviceName: \(UIDevice.current.name)" +
                        "\nModel: \(UIDevice.current.model)" +
                        "\nCurrent Time: \(date)" +
                        "\niOS: \(UIDevice.current.systemVersion)" +
                        "\n\nApplication Information" +
                        "\nVersion: \(self.version())" +
                        "\nBuild #: \(buildNum)" +
                        "\nFeedback ID: \(uuid)"
                    
                    do {
                        // Write to the file
                        try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                        
                        let composeVC = MFMailComposeViewController()
                        
                        composeVC.mailComposeDelegate = self
                        composeVC.setToRecipients(["wyatt@thrive-fl.org"])
                        composeVC.setSubject("Thrive iOS - ID: \(uuid)")
                        
                        if let fileData = NSData(contentsOfFile: fileURL.path) {
                            composeVC.addAttachmentData(fileData as Data,
                                                        mimeType: "text/plain",
                                                        fileName: "\(uuid).log")
                        }
                        self.present(composeVC, animated: true, completion: nil)
                        
                    } catch let error as NSError {
                        print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
                        
                        self.displayAlertForAction()
                    }
                }
                else {
                    self.displayAlertForAction()
                }
                    
            }))
           
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            self.present(alert, animated: true)
		}
		else if (config.CellTitle == "Settings") {
            self.openUrlAnyways(link: UIApplication.openSettingsURLString)
		}
		else {
			self.show(config.Destination, sender: self)
		}
	}
	
	// MARK: - Methods
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as? String ?? ""
        return "\(version)"
    }
    
    func build() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let build = dictionary["CFBundleVersion"] as? String ?? ""
        return "\(build)"
    }
    
    //Standard Mail compose controller code
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
    
    func getDate() -> String {
        
        let stringFromDate = Date().iso8601    // "2017-03-22T13:22:13.933Z"
        if let dateFromString = stringFromDate.dateFromISO8601 {
            return dateFromString.iso8601      // "2017-03-22T13:22:13.933Z"
        }
        return stringFromDate
    }
	
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
            do {
                if let decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: imNewData!) {
                    let newVC = GenericSiteViewController()
                    newVC.link = decoded.Value!
                    newVC.navHeader = "I'm New"
                    
                    let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: newVC,
                                                                                         setting: decoded,
                                                                                         title: "I'm New")
                    
                    tempList.append(settingToAdd)
                }
            }
            catch {}
		}
		
		if giveData != nil {
			
			// reading from the messageId collection in UD
            do {
                if let decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: giveData!) {
                    let nowhere = UIViewController()
                    
                    let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: nowhere,
                                                                                         setting: decoded,
                                                                                         title: "Give")
                    
                    tempList.append(settingToAdd)
                }
            }
            catch {}
		}
		
		if (fbData != nil || fbPageData != nil || igData != nil || igUsernameData != nil ||
				twData != nil || twUsernameData != nil) {
			
			let vc = UIAlertController(title: "Social",
									   message: "Please select an option",
									   preferredStyle: .actionSheet)
						
			if (fbPageData != nil) {
								
				vc.addAction(UIAlertAction(title: "Facebook", style: .default, handler: { (action) in
					
                    
                    var decoded: ConfigSetting? = nil
                    
                    do {
                        decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: fbPageData!)
                    }
                    catch {
                        
                    }
					
					let fbId = "\(decoded?.Value ?? "157139164480128")"
					
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
                    
                    var decoded: ConfigSetting? = nil
                    
                    do {
                        decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: fbData!)
                    }
                    catch {
                        
                    }
										
					let fbURL = URL(string: "\(decoded?.Value ?? "")")!
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
					
                    var decoded: ConfigSetting? = nil
                    
                    do {
                        decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: igUsernameData!)
                    }
                    catch {
                        
                    }
                    
					let igUsername = "\(decoded?.Value ?? "thrive_fl")"

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
					
                    var decoded: ConfigSetting? = nil
                    
                    do {
                        decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: igData!)
                    }
                    catch {
                        
                    }
					
					let igURL = URL(string: "\(decoded?.Value ?? "")")!
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
				
				vc.addAction(UIAlertAction(title: "X", style: .default, handler: { (action) in
					
                    var decoded: ConfigSetting? = nil
                    
                    do {
                        decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: twUsernameData!)
                    }
                    catch {
                        
                    }
					
					let twUsername = "\(decoded?.Value ?? "Thrive_FL")"

					let appURL = URL(string: "twitter:///user?screen_name=\(twUsername)")!
					print(appURL.absoluteString)
					
					if UIApplication.shared.canOpenURL(appURL) {
						UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
					}
					else {
						let message = "You need to download the X app first"
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
				
				vc.addAction(UIAlertAction(title: "X", style: .default, handler: { (action) in
					
                    var decoded: ConfigSetting? = nil
                    
                    do {
                        decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: twData!)
                    }
                    catch {
                        
                    }
                    
					let twURL = URL(string: "\(decoded?.Value ?? "")")!
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
            do {
                if let decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: teamData!) {
                    let teamVC = GenericSiteViewController()
                    teamVC.link = decoded.Value!
                    teamVC.navHeader = "Meet the team"
                    
                    let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: teamVC,
                                                                                         setting: decoded,
                                                                                         title: "Meet the team")
                    
                    tempList.append(settingToAdd)
                }
            }
            catch {}
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
