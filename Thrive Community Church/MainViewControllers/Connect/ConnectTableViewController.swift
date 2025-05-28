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

        setupTableView()
        setupNavigationBar()
		self.configurations = self.loadConfigs()
    }

    // MARK: - Setup Views
    func setupTableView() {
        tableView.backgroundColor = UIColor.almostBlack
        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 80 // Increased height for card design
        tableView.register(ModernConnectTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        // Add spacing for card layout
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }

    func setupNavigationBar() {
        title = "Connect"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ModernConnectTableViewCell

		let config = configurations[indexPath.row]

		if let config = config {
			// Determine subtitle based on content type
			var subtitle: String? = nil

			if config.CellTitle == "Get directions", let setting = config.Setting {
				subtitle = setting.Value // Show address as subtitle
			} else if config.CellTitle == "Contact us" {
				subtitle = "Email, call, or submit prayer requests"
			} else if config.CellTitle == "Announcements" {
				subtitle = "Latest church news and updates"
			} else if config.CellTitle == "Join a small group" {
				subtitle = "Connect with others in community"
			} else if config.CellTitle == "Serve" {
				subtitle = "Find ways to get involved"
			}

			cell.configure(title: config.CellTitle, subtitle: subtitle)
		}

        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let config = configurations[indexPath.row]!

		tableView.deselectRow(at: indexPath, animated: true)

		if (config.Setting?.Key == ConfigKeys.shared.AddressMain) {
			let formattedAddress = config.Setting?.Value?.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")

			self.openUrlAnyways(link: "http://maps.apple.com/?daddr=\(formattedAddress ?? ""))&dirflg=d")
		}
		else if (config.Setting == nil && config.CellTitle != "Announcements") {
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
                var decoded: ConfigSetting? = nil

                do {
                    decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: emailData!)
                }
                catch {

                }

				email = "\(decoded?.Value ?? "info@thrive-fl.org")"

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
                    var decoded: ConfigSetting? = nil

                    do {
                        decoded = try NSKeyedUnarchiver.unarchivedObject(ofClass: ConfigSetting.self, from: phoneData!)
                    }
                    catch {

                    }

					if let url = URL(string: "tel://\(decoded?.Value ?? "2396873430")") {

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
                    if let prayerDecoded = NSKeyedUnarchiver.safelyUnarchiveConfigSetting(from: prayersData!) {
                        let prayerVC = GenericSiteViewController()
                        prayerVC.link = prayerDecoded.Value!
                        prayerVC.navHeader = "Prayer request"

                        self.show(prayerVC, sender: self)
                    }
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
                decoded = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses as! Set<AnyHashable>, from: addressData!) as? ConfigSetting
            } catch {
                decoded = nil
            }

			let nowhere = UIViewController()

			let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: nowhere,
																				 setting: decoded,
																				 title: "Get directions")

			tempList.append(settingToAdd)
		}

		if smallGroupData != nil {

			// reading from the messageId collection in UD
            if let decoded = NSKeyedUnarchiver.safelyUnarchiveConfigSetting(from: smallGroupData!) {
                let groupsVC = GenericSiteViewController()
                groupsVC.link = decoded.Value!
                groupsVC.navHeader = "Join a small group"

                let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: groupsVC,
                                                                                     setting: decoded,
                                                                                     title: "Join a small group")

                tempList.append(settingToAdd)
            }
		}

		if serveData != nil {

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
                if let decoded = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses as! Set<AnyHashable>, from: serveData!) as? ConfigSetting {
                    let groupsVC = GenericSiteViewController()
                    groupsVC.link = decoded.Value!
                    groupsVC.navHeader = "Serve"

                    let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: groupsVC,
                                                                                         setting: decoded,
                                                                                         title: "Serve")

                    tempList.append(settingToAdd)
                }
            } catch {
                // Handle error silently
            }
		}

		let announcementsVC = RSSTableViewController()

		let settingToAdd: DynamicConfigResponse = DynamicConfigResponse.init(destination: announcementsVC,
																			 setting: nil,
																			 title: "Announcements")

		tempList.append(settingToAdd)

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

// MARK: - Modern Connect Table View Cell

class ModernConnectTableViewCell: UITableViewCell {

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
            // Card container constraints with 16pt horizontal margins and 8pt vertical spacing
            cardContainer.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 4),
            bottomConstraint,
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

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