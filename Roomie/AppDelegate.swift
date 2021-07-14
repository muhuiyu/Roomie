//
//  AppDelegate.swift
//  Roomie
//
//  Created by Mu Yu on 2/7/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let homeViewController = HomeViewController()
        let chatViewController = ChatViewController()
        let listViewController = ListViewController()
        let mealsViewController = MealsViewController()
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            mealsViewController.embedInNavgationController(),
            homeViewController.embedInNavgationController(),
            chatViewController.embedInNavgationController(),
            listViewController.embedInNavgationController(),
        ]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        return true
    }

}
