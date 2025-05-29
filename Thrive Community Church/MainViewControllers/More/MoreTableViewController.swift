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

        setupTableView()
        setupNavigationBar()
		self.configurations = self.loadConfigs()

		// Ensure view background matches table view to prevent white bars
		view.backgroundColor = UIColor.almostBlack
    }

    // MARK: - Setup Views
    func setupTableView() {
        tableView.backgroundColor = UIColor.almostBlack
        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 80 // Increased height for card design
        tableView.register(ModernMoreTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        // Add spacing for card layout
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        // Ensure table view extends to bottom edge without white bar (iOS 15+ minimum deployment target)
        tableView.contentInsetAdjustmentBehavior = .automatic

        // Ensure table view fills entire view
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
    }

    func setupNavigationBar() {
        title = "More"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return configurations.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ModernMoreTableViewCell

		let config = configurations[indexPath.row]

		if let config = config {
			// Determine subtitle based on content type
			var subtitle: String? = nil

			if config.CellTitle == "I'm New" {
				subtitle = "Learn about our church and community"
			} else if config.CellTitle == "Give" {
				subtitle = "Support our mission and ministry"
			} else if config.CellTitle == "Social" {
				subtitle = "Follow us on social media"
			} else if config.CellTitle == "Meet the team" {
				subtitle = "Get to know our staff and leadership"
			} else if config.CellTitle == "Bible" {
				subtitle = "Read scripture with YouVersion integration"
			} else if config.CellTitle == "Settings" {
				subtitle = "Manage app preferences and notifications"
			} else if config.CellTitle == "About" {
				subtitle = "App version and information"
			} else if config.CellTitle == "Send Logs" {
				subtitle = "Send diagnostic information to support"
			}

			cell.configure(title: config.CellTitle, subtitle: subtitle)
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let config = configurations[indexPath.row]!

		tableView.deselectRow(at: indexPath, animated: true)

		if (config.CellTitle == "Social") {
			// Configure popover for iPad if it's an action sheet
			if let alertController = config.Destination as? UIAlertController {
				configurePopoverForActionSheet(alertController, sourceIndexPath: indexPath)
			}
			self.present(config.Destination, animated: true, completion: nil)
		}
		else if (config.Setting?.Key == ConfigKeys.shared.Give) {
			self.openUrlAnyways(link: config.Setting?.Value ?? "")
		}
		else if (config.CellTitle == "Send Logs") {
			self.sendLogsToSupport()
		}
		else if (config.CellTitle == "About") {
            let year = Calendar.current.component(.year, from: Date())

            let alert = UIAlertController(title: "About Thrive Church App",
                                          message: "Version: \(self.version()) (Build \(self.build()))\n\n©\(year) Thrive Community Church\n\nThis app helps you stay connected with our church community, access sermons, take notes, and more.",
                                          preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel))

            // Configure popover for iPad
            if let popover = alert.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popover.sourceView = cell
                    popover.sourceRect = cell.bounds
                } else {
                    popover.sourceView = tableView
                    popover.sourceRect = CGRect(x: tableView.bounds.midX, y: tableView.bounds.midY, width: 0, height: 0)
                }
                popover.permittedArrowDirections = [.up, .down]
            }

            self.present(alert, animated: true)
		}
		else if (config.CellTitle == "Settings") {
            self.openUrlAnyways(link: UIApplication.openSettingsURLString)
		}
		else if (config.CellTitle == "Bible") {
			self.show(config.Destination, sender: self)
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

    func sendLogsToSupport() {
        // Check if device can send mail
        if MFMailComposeViewController.canSendMail() {
            let year = Calendar.current.component(.year, from: Date())

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
                composeVC.setMessageBody("Please describe any issues you're experiencing with the app:", isHTML: false)

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
    }

    // MARK: - Helper Methods

    private func configurePopoverForActionSheet(_ alertController: UIAlertController, sourceIndexPath: IndexPath) {
        if let popover = alertController.popoverPresentationController {
            if let cell = tableView.cellForRow(at: sourceIndexPath) {
                popover.sourceView = cell
                popover.sourceRect = cell.bounds
            } else {
                popover.sourceView = tableView
                popover.sourceRect = CGRect(x: tableView.bounds.midX, y: tableView.bounds.midY, width: 0, height: 0)
            }
            popover.permittedArrowDirections = [.up, .down]
        }
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
            // Use secure coding with explicit allowed classes
            let allowedClasses = NSSet(array: [
                ConfigSetting.self,
                NSString.self,
                NSNumber.self,
                NSData.self,
                NSDate.self
            ])

            do {
                if let decoded = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses as! Set<AnyHashable>, from: imNewData!) as? ConfigSetting {
                    let newVC = GenericSiteViewController()
                    newVC.link = decoded.Value!
                    newVC.navHeader = "I'm New"

                    let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: newVC,
                                                                                         setting: decoded,
                                                                                         title: "I'm New")

                    tempList.append(settingToAdd)
                }
            } catch {
                // Handle error silently
            }
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
            // Use secure coding with explicit allowed classes
            let allowedClasses = NSSet(array: [
                ConfigSetting.self,
                NSString.self,
                NSNumber.self,
                NSData.self,
                NSDate.self
            ])

            do {
                if let decoded = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses as! Set<AnyHashable>, from: teamData!) as? ConfigSetting {
                    let teamVC = GenericSiteViewController()
                    teamVC.link = decoded.Value!
                    teamVC.navHeader = "Meet the team"

                    let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: teamVC,
                                                                                         setting: decoded,
                                                                                         title: "Meet the team")

                    tempList.append(settingToAdd)
                }
            } catch {
                // Handle error silently
            }
		}

		let nowhere = UIViewController()

		// Add Bible option
		let bibleSelectionVC = BibleSelectionViewController()
		let bibleOption: DynamicConfigResponse = DynamicConfigResponse.init(destination: bibleSelectionVC,
																		   setting: nil,
																		   title: "Bible")
		tempList.append(bibleOption)

		let settingsOption: DynamicConfigResponse = DynamicConfigResponse.init(destination: nowhere,
																			 setting: nil,
																			 title: "Settings")
		tempList.append(settingsOption)

		let sendLogsOption: DynamicConfigResponse = DynamicConfigResponse.init(destination: nowhere,
																			 setting: nil,
																			 title: "Send Logs")
		tempList.append(sendLogsOption)

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

// MARK: - Modern More Table View Cell

class ModernMoreTableViewCell: UITableViewCell {

    // MARK: - UI Elements

    // Card Container
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGrey
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.4
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Title Label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Subtitle Label
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Disclosure Indicator
    private let disclosureIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Setup Methods

    private func setupViews() {
        backgroundColor = .almostBlack
        selectionStyle = .none

        // Configure cell appearance
        layer.masksToBounds = false

        // Add main container
        contentView.addSubview(cardContainer)

        // Add content to card
        cardContainer.addSubview(titleLabel)
        cardContainer.addSubview(subtitleLabel)
        cardContainer.addSubview(disclosureIndicator)

        setupConstraints()
    }

    private func setupConstraints() {
        // Create bottom constraint with lower priority to avoid conflicts
        let bottomConstraint = cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        bottomConstraint.priority = UILayoutPriority(999) // High but not required

        NSLayoutConstraint.activate([
            // Card container constraints with adaptive width for iPad
            cardContainer.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 4),
            bottomConstraint,
            cardContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            // Width constraints for adaptive layout
            cardContainer.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            cardContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 600), // Maximum width for readability

            // Prefer to fill available width but respect maximum
            {
                let widthConstraint = cardContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32)
                widthConstraint.priority = .defaultHigh
                return widthConstraint
            }(),

            // Minimum height constraint to prevent zero-height issues
            cardContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 72),

            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: disclosureIndicator.leadingAnchor, constant: -12),

            // Subtitle label constraints
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: disclosureIndicator.leadingAnchor, constant: -12),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardContainer.bottomAnchor, constant: -12),

            // Disclosure indicator constraints
            disclosureIndicator.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            disclosureIndicator.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            disclosureIndicator.widthAnchor.constraint(equalToConstant: 8),
            disclosureIndicator.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    // MARK: - Configuration

    func configure(title: String, subtitle: String?) {
        titleLabel.text = title

        if let subtitle = subtitle, !subtitle.isEmpty {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
    }

    // MARK: - Touch Animation

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animatePress(pressed: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animatePress(pressed: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animatePress(pressed: false)
    }

    private func animatePress(pressed: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction) {
            self.transform = pressed ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            self.cardContainer.layer.shadowOpacity = pressed ? 0.2 : 0.4
        }
    }
}
