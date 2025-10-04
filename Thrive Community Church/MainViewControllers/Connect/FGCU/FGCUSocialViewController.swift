//
//  FGCUSocialViewController.swift
//  Thrive Church Official App
//
//  Created by Thrive on 9/9/16.
//  Copyright © 2016 Thrive Community Church. All rights reserved.
//

import UIKit

class FGCUSocialViewController: UIViewController {

    // UI Elements
    let facebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Facebook", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let instagramButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Instagram", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 225/255, green: 48/255, blue: 108/255, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Setup Views
    func setupViews() {
        view.backgroundColor = UIColor.almostBlack

        view.addSubview(facebookButton)
        view.addSubview(instagramButton)

        NSLayoutConstraint.activate([
            facebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            facebookButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            facebookButton.widthAnchor.constraint(equalToConstant: 200),
            facebookButton.heightAnchor.constraint(equalToConstant: 50),

            instagramButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instagramButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 20),
            instagramButton.widthAnchor.constraint(equalToConstant: 200),
            instagramButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupActions() {
        facebookButton.addTarget(self, action: #selector(facebookButtonTapped), for: .touchUpInside)
        instagramButton.addTarget(self, action: #selector(instagramButtonTapped), for: .touchUpInside)
    }

    @objc func facebookButtonTapped() {
		guard let fbURLID = URL(string: "fb://profile/587219548105074") else { return }
		guard let fbURL = URL(string: "https://www.facebook.com/thriveFGCU/") else { return }

        if UIApplication.shared.canOpenURL(fbURLID) {
			UIApplication.shared.open(fbURL, options: [:], completionHandler: nil)
        }
        else {
           UIApplication.shared.open(fbURL, options: [:], completionHandler: nil)
       }
    }

    @objc func instagramButtonTapped() {
		guard let instagramLink = URL(string: "instagram://user?username=thrivefgcu") else { return }
		guard let instaURL = URL(string: "https://www.instagram.com/thrivefgcu/") else { return }

        if UIApplication.shared.canOpenURL(instagramLink) {
            UIApplication.shared.open(instagramLink, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.open(instaURL, options: [:], completionHandler: nil)
        }
    }
}
