//
//  AppDelegate.swift
//  Roomie
//
//  Created by Mu Yu on 2/7/21.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
//        let database = DatabaseDataSource()
//        let ingredients: [IngredientEntry] = [
//
//        ]
//        database.setIngredients(with: ingredients) { error in
//            if let error = error {
//                print(error)
//                fatalError()
//            }
//        }
//
//        let recipes: [RecipeEntry] = [
//            RecipeEntry(id: "recipe-corn-and-cream-korokke",
//                        name: "コーンコロッケ (corn & cream korokke)",
//                        subtitle: "this is subtitle",
//                        imageName: "recipe-corn-and-cream-korokke",
//                        meals: [],
//                        tags: [.deepFry],
//                        cuisines: [.japanese],
//                        categories: [.sidedish],
//                        servings: 2,
//                        ingredients: [
//
//                        ],
//                        instructions: [
//                            ""
//                        ]),
//        ]
//        database.setRecipes(with: recipes) { error in
//            if let error = error {
//                print(error)
//                fatalError()
//            }
//        }
        
        if let _ = Auth.auth().currentUser {
            setViewControllers(window: window)
        }
        else {
            let welcomeViewController = WelcomeViewController()
            welcomeViewController.delegate = self
            window.rootViewController = welcomeViewController
        }
        window.makeKeyAndVisible()
        return true
    }

}
extension AppDelegate {
    private func setViewControllers(window: UIWindow) {
        let database = DatabaseDataSource()
        
        database.setup(using: "baj3tAjA3m7r2jT8scPG") { error in
            if let error = error {
                print(error)
                return
            }
        }
        
        let homeViewController = HomeViewController(database: database)
//        let chatViewController = ChatViewController()
        let listViewController = ListViewController()
        let settingsViewController = SettingsViewController()
        settingsViewController.delegate = self
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            homeViewController.embedInNavgationController(),
//            chatViewController.embedInNavgationController(),
            listViewController.embedInNavgationController(),
            settingsViewController.embedInNavgationController()
        ]
        window.rootViewController = tabBarController
    }
}
extension AppDelegate: WelcomeViewControllerDelegate, SettingsViewControllerDelegate {
    func welcomeViewControllerDidLoginSuccessfully(_ controller: WelcomeViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        setViewControllers(window: window)
        window.makeKeyAndVisible()
    }
    func settingsViewControllerDidLogoutSuccessfully(_ controller: SettingsViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let welcomeViewController = WelcomeViewController()
        welcomeViewController.delegate = self
        window.rootViewController = welcomeViewController
        window.makeKeyAndVisible()
    }
}
