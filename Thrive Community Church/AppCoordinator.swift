//
//  AppCoordinator.swift
//  Thrive Church Official App
//
//  Created by AI Assistant on Migration Day
//  Copyright © 2024 Thrive Community Church. All rights reserved.
//

import UIKit

class AppCoordinator {

    var window: UIWindow?
    var tabBarController: UITabBarController!

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        setupTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    private func setupTabBarController() {
        tabBarController = UITabBarController()
        tabBarController.tabBar.barStyle = .black
        tabBarController.tabBar.backgroundColor = UIColor.black
        tabBarController.tabBar.barTintColor = UIColor.black
        tabBarController.tabBar.tintColor = UIColor(red: 0.199, green: 0.729, blue: 0.830, alpha: 1.0)
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
        tabBarController.tabBar.isTranslucent = false

        // Set appearance for iOS 13+
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black
            tabBarController.tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBarController.tabBar.scrollEdgeAppearance = appearance
            }
        }

        // Create all the navigation controllers
        let listenNavController = createListenNavigationController()
        let bibleNavController = createBibleNavigationController()
        let connectNavController = createConnectNavigationController()
        let moreNavController = createMoreNavigationController()

        // Set the view controllers
        tabBarController.viewControllers = [
            listenNavController,
            bibleNavController,
            connectNavController,
            moreNavController
        ]
    }

    private func createListenNavigationController() -> UINavigationController {
        let listenVC = ListenCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: listenVC)

        // Configure navigation bar
        setupNavigationBar(navController)

        // Configure tab bar item
        navController.tabBarItem = UITabBarItem(
            title: "Listen",
            image: UIImage(named: "Listen"),
            tag: 0
        )

        return navController
    }

    private func createBibleNavigationController() -> UINavigationController {
        let masterVC = MasterViewController()
        let navController = UINavigationController(rootViewController: masterVC)

        // Configure navigation bar
        setupNavigationBar(navController)

        // Configure tab bar item
        navController.tabBarItem = UITabBarItem(
            title: "Notes",
            image: UIImage(named: "notes"),
            tag: 1
        )

        return navController
    }

    private func createConnectNavigationController() -> UINavigationController {
        let connectVC = ConnectTableViewController()
        let navController = UINavigationController(rootViewController: connectVC)

        // Configure navigation bar
        setupNavigationBar(navController)

        // Configure tab bar item
        navController.tabBarItem = UITabBarItem(
            title: "Connect",
            image: UIImage(named: "Connect"),
            tag: 2
        )

        return navController
    }

    private func createMoreNavigationController() -> UINavigationController {
        let moreVC = MoreTableViewController()
        let navController = UINavigationController(rootViewController: moreVC)

        // Configure navigation bar
        setupNavigationBar(navController)

        // Configure tab bar item
        navController.tabBarItem = UITabBarItem(
            title: "More",
            image: UIImage(named: "More"),
            tag: 3
        )

        return navController
    }



    private func setupNavigationBar(_ navController: UINavigationController) {
        navController.navigationBar.barStyle = .black
        navController.navigationBar.tintColor = UIColor(red: 0.199, green: 0.729, blue: 0.830, alpha: 1.0)
        navController.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "Avenir-Black", size: 19) ?? UIFont.systemFont(ofSize: 19, weight: .black),
            .foregroundColor: UIColor.white
        ]
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.backgroundColor = UIColor.black
        navController.navigationBar.barTintColor = UIColor.black

        // Ensure navigation bar is visible
        navController.setNavigationBarHidden(false, animated: false)
        navController.navigationBar.prefersLargeTitles = false

        // Set appearance for iOS 13+
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black
            appearance.titleTextAttributes = [
                .font: UIFont(name: "Avenir-Black", size: 19) ?? UIFont.systemFont(ofSize: 19, weight: .black),
                .foregroundColor: UIColor.white
            ]
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
