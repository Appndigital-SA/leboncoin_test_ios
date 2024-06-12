//
//  AppDelegate.swift
//  leboncoin
//
//  Created by Didier Nizard on 11/06/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let navigationVC = UINavigationController()
        
        window.rootViewController = navigationVC
        
        let mainVC = MainViewController()
        
        navigationVC.pushViewController(mainVC, animated: false)
        window.makeKeyAndVisible()
        
        return true
    }
}

