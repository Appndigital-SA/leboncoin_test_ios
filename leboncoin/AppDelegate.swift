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
        navigationVC.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.accent
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationVC.navigationBar.tintColor = .white
        navigationVC.navigationBar.standardAppearance = appearance
        navigationVC.navigationBar.scrollEdgeAppearance = appearance
        
        window.rootViewController = navigationVC
        
        let mainVC = MainViewController()
        
        navigationVC.pushViewController(mainVC, animated: false)
        window.makeKeyAndVisible()
        
        return true
    }
}

