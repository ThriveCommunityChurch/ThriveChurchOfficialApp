//
//  BibleSelectionViewController.swift
//  Thrive Church Official App
//
//  Created by Augment Agent on 12/19/24.
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import UIKit

class BibleSelectionViewController: UIViewController {

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.almostBlack
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.almostBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose how you'd like to browse the Bible"
        label.font = UIFont(name: "Avenir-Book", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let traditionalCard: UIView = {
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

    private let alphabeticalCard: UIView = {
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

    private let traditionalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Traditional Order"
        label.font = UIFont(name: "Avenir-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let traditionalDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Browse books in biblical order\nGenesis → Malachi → Matthew → Revelation"
        label.font = UIFont(name: "Avenir-Book", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let alphabeticalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Alphabetical Order"
        label.font = UIFont(name: "Avenir-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let alphabeticalDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Browse books alphabetically\n1 Chronicles → Acts → Daniel → Zechariah"
        label.font = UIFont(name: "Avenir-Book", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let traditionalChevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let alphabeticalChevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupGestures()

        // Ensure view background matches to prevent white bars
        view.backgroundColor = UIColor.almostBlack

        // Ensure view fills entire screen
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = .all
    }

    // MARK: - Setup Methods

    private func setupViews() {
        title = "Bible"

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(subtitleLabel)
        contentView.addSubview(traditionalCard)
        contentView.addSubview(alphabeticalCard)

        traditionalCard.addSubview(traditionalTitleLabel)
        traditionalCard.addSubview(traditionalDescriptionLabel)
        traditionalCard.addSubview(traditionalChevron)

        alphabeticalCard.addSubview(alphabeticalTitleLabel)
        alphabeticalCard.addSubview(alphabeticalDescriptionLabel)
        alphabeticalCard.addSubview(alphabeticalChevron)
    }

    private func setupConstraints() {
        let margins = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: margins.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Subtitle label constraints
            subtitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

            // Traditional card constraints
            traditionalCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            traditionalCard.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            traditionalCard.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            traditionalCard.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            traditionalCard.widthAnchor.constraint(lessThanOrEqualToConstant: 600), // Maximum width for readability
            traditionalCard.heightAnchor.constraint(equalToConstant: 100), // Increased height for better text readability

            // Alphabetical card constraints
            alphabeticalCard.topAnchor.constraint(equalTo: traditionalCard.bottomAnchor, constant: 16),
            alphabeticalCard.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            alphabeticalCard.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            alphabeticalCard.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            alphabeticalCard.widthAnchor.constraint(lessThanOrEqualToConstant: 600), // Maximum width for readability
            alphabeticalCard.widthAnchor.constraint(equalTo: traditionalCard.widthAnchor), // Ensure identical width
            alphabeticalCard.heightAnchor.constraint(equalToConstant: 100), // Increased height for better text readability
            alphabeticalCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

            // Traditional card content constraints
            traditionalTitleLabel.topAnchor.constraint(equalTo: traditionalCard.topAnchor, constant: 16),
            traditionalTitleLabel.leadingAnchor.constraint(equalTo: traditionalCard.leadingAnchor, constant: 16),
            traditionalTitleLabel.trailingAnchor.constraint(equalTo: traditionalChevron.leadingAnchor, constant: -12),

            traditionalDescriptionLabel.topAnchor.constraint(equalTo: traditionalTitleLabel.bottomAnchor, constant: 4),
            traditionalDescriptionLabel.leadingAnchor.constraint(equalTo: traditionalCard.leadingAnchor, constant: 16),
            traditionalDescriptionLabel.trailingAnchor.constraint(equalTo: traditionalChevron.leadingAnchor, constant: -12),
            traditionalDescriptionLabel.bottomAnchor.constraint(equalTo: traditionalCard.bottomAnchor, constant: -16),

            traditionalChevron.centerYAnchor.constraint(equalTo: traditionalCard.centerYAnchor),
            traditionalChevron.trailingAnchor.constraint(equalTo: traditionalCard.trailingAnchor, constant: -16),
            traditionalChevron.widthAnchor.constraint(equalToConstant: 8),
            traditionalChevron.heightAnchor.constraint(equalToConstant: 12),

            // Alphabetical card content constraints
            alphabeticalTitleLabel.topAnchor.constraint(equalTo: alphabeticalCard.topAnchor, constant: 16),
            alphabeticalTitleLabel.leadingAnchor.constraint(equalTo: alphabeticalCard.leadingAnchor, constant: 16),
            alphabeticalTitleLabel.trailingAnchor.constraint(equalTo: alphabeticalChevron.leadingAnchor, constant: -12),

            alphabeticalDescriptionLabel.topAnchor.constraint(equalTo: alphabeticalTitleLabel.bottomAnchor, constant: 4),
            alphabeticalDescriptionLabel.leadingAnchor.constraint(equalTo: alphabeticalCard.leadingAnchor, constant: 16),
            alphabeticalDescriptionLabel.trailingAnchor.constraint(equalTo: alphabeticalChevron.leadingAnchor, constant: -12),
            alphabeticalDescriptionLabel.bottomAnchor.constraint(equalTo: alphabeticalCard.bottomAnchor, constant: -16),

            alphabeticalChevron.centerYAnchor.constraint(equalTo: alphabeticalCard.centerYAnchor),
            alphabeticalChevron.trailingAnchor.constraint(equalTo: alphabeticalCard.trailingAnchor, constant: -16),
            alphabeticalChevron.widthAnchor.constraint(equalToConstant: 8),
            alphabeticalChevron.heightAnchor.constraint(equalToConstant: 12),
        ])
    }

    private func setupGestures() {
        let traditionalTap = UITapGestureRecognizer(target: self, action: #selector(traditionalCardTapped))
        traditionalCard.addGestureRecognizer(traditionalTap)
        traditionalCard.isUserInteractionEnabled = true

        let alphabeticalTap = UITapGestureRecognizer(target: self, action: #selector(alphabeticalCardTapped))
        alphabeticalCard.addGestureRecognizer(alphabeticalTap)
        alphabeticalCard.isUserInteractionEnabled = true
    }

    // MARK: - Actions

    @objc private func traditionalCardTapped() {
        animateCardPress(traditionalCard) {
            let traditionalVC = TraditionalSortBibleTableViewController()
            traditionalVC.title = "Bible - Traditional"
            self.navigationController?.pushViewController(traditionalVC, animated: true)
        }
    }

    @objc private func alphabeticalCardTapped() {
        animateCardPress(alphabeticalCard) {
            let alphabeticalVC = AlphabeticalSortBibleTableViewController()
            alphabeticalVC.title = "Bible - Alphabetical"
            self.navigationController?.pushViewController(alphabeticalVC, animated: true)
        }
    }

    private func animateCardPress(_ card: UIView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {
            card.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            card.layer.shadowOpacity = 0.2
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                card.transform = .identity
                card.layer.shadowOpacity = 0.4
            }) { _ in
                completion()
            }
        }
    }
}
