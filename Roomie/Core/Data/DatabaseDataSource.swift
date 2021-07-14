//
//  DatabaseDataSource.swift
//  Roomie
//
//  Created by Mu Yu on 13/7/21.
//

import UIKit
import Firebase

class DatabaseDataSource: NSObject {
    enum CollectionName: String {
        case chat = "chat"
        case ingredient = "ingredient"
        case meals = "meals"
        case recipes = "recipes"
    }
}

// MARK: - Fetch
extension DatabaseDataSource {
    func fetchMeals() -> [MealEntry] {
        
    }
    func fetchRecipe() -> RecipeEntry {
        
    }
    func fetchRecipes() -> [RecipeEntry] {
        
    }
}
