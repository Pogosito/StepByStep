//
//  AppDelegate.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 15.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow()
		window?.rootViewController = UINavigationController(rootViewController: MenuTableViewController(style: .insetGrouped))
		window?.makeKeyAndVisible()
		return true
	}
}
