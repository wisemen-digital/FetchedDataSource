//
//  AppDelegate.swift
//  Example
//
//  Created by David Jennes on 23/12/16.
//  Copyright (c) 2016 dj. All rights reserved.
//

import MagicalRecord
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {

		MagicalRecord.setupCoreDataStackWithInMemoryStore()
		MagicalRecord.setLoggingLevel(.warn)

		return true
	}
}
