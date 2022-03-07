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
    let database = DatabaseDataSource()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let ingredients: [IngredientEntry] = [
            
        ]
        database.setIngredients(with: ingredients) { error in
            if let error = error {
                print(error)
                fatalError()
            }
        }
        let recipes: [RecipeEntry] = [
            
            RecipeEntry(id: "recipe-stir-fry-pork-mince-with-fish-sauce",
                        name: "ナンプラーで豚そぼろ (stir-fried pork mince with fish sauce)",
                        subtitle: "this is subtitle",
                        imageStoragePath: "recipe-images/recipe-stir-fry-pork-mince-with-fish-sauce.jpg",
                        meals: [],
                        tags: [.pork, .riceBowl, .stirFry],
                        cuisines: [.vietnamese],
                        categories: [.mainCourse],
                        servings: 1,
                        ingredients: [
                            RecipeIngredientEntry(id: "ingredient-minced-pork", amount: 100, unit: .gram),
                            RecipeIngredientEntry(id: "ingredient-onion", amount: 0.5, unit: .each),
                            RecipeIngredientEntry(id: "ingredient-garlic", amount: 1, unit: .each),
                            RecipeIngredientEntry(id: "ingredient-rice-wine", amount: 1, unit: .teaspoon),
                            RecipeIngredientEntry(id: "ingredient-fish-sauce", amount: 1, unit: .teaspoon),
                            RecipeIngredientEntry(id: "ingredient-lemon-juice", amount: 1, unit: .teaspoon),
                            RecipeIngredientEntry(id: "ingredient-sugar", amount: 0.5, unit: .teaspoon),
                            RecipeIngredientEntry(id: "ingredient-spring-onion", amount: 1, unit: .each),
                        ],
                        instructions: [
                            "Fry the garlic and onion. Add meat and rice wine in. Stir-fry until there's no water inside.",
                            "Add fish sauce, lemon juice and sugar.",
                            "Serve with coriander and spring onion."
                        ]),
        ]
        database.setRecipes(with: recipes) { error in
            if let error = error {
                print(error)
                fatalError()
            }
        }

        database.setup(asGroup: "baj3tAjA3m7r2jT8scPG") { error in
            if let error = error {
                print(error)
                return
            }
            
            if let _ = Auth.auth().currentUser {
                self.setViewControllers(window: window)
            }
            else {
                let welcomeViewController = WelcomeViewController()
                welcomeViewController.delegate = self
                window.rootViewController = welcomeViewController
            }
            window.makeKeyAndVisible()
        }
        return true
    }

}
extension AppDelegate {
    private func setViewControllers(window: UIWindow) {
        let homeViewController = HomeViewController(database: self.database)
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
