//
//  RecipeEntry.swift
//  Roomie
//
//  Created by Mu Yu on 12/7/21.
//

import UIKit
import Firebase

struct RecipeEntry {
    let id: RecipeID
    let name: String
    let subtitle: String
    let imageName: String
    let meals: [RecipeMeal]
    let tags: [RecipeTag]
    let cuisines: [RecipeCuisine]
    let categories: [RecipeCategory]
    let servings: Int
    let ingredients: [RecipeIngredientEntry]
    let instructions: [String]
    
    init?(document: DocumentSnapshot) {
        self.id = document.documentID
        guard
            let data = document.data(),
            let name = data[DatabaseDataSource.KeyName.name] as? String,
            let subtitle = data[DatabaseDataSource.KeyName.subtitle] as? String,
            let imageName = data[DatabaseDataSource.KeyName.imageName] as? String,
            let mealsRawData = data[DatabaseDataSource.KeyName.meals] as? [String],
            let tagsRawData = data[DatabaseDataSource.KeyName.tags] as? [String],
            let cuisinesRawData = data[DatabaseDataSource.KeyName.cuisines] as? [String],
            let categoriesRawData = data[DatabaseDataSource.KeyName.categories] as? [String],
            let servings = data[DatabaseDataSource.KeyName.servings] as? Int,
            let ingredientsRawData = data[DatabaseDataSource.KeyName.ingredients] as? [[String: Any]],
            let instructions = data[DatabaseDataSource.KeyName.instructions] as? [String]
        else { return nil }
        
        self.name = name
        self.subtitle = subtitle
        self.imageName = imageName
        self.servings = servings
        self.instructions = instructions
        
        var meals = [RecipeMeal]()
        for mealRawData in mealsRawData {
            guard let meal = RecipeMeal(rawValue: mealRawData) else { return nil }
            meals.append(meal)
        }
        self.meals = meals
        
        var tags = [RecipeTag]()
        for tagRawData in tagsRawData {
            guard let tag = RecipeTag(rawValue: tagRawData) else { return nil }
            tags.append(tag)
        }
        self.tags = tags
        
        var cuisines = [RecipeCuisine]()
        for cuisineRawData in cuisinesRawData {
            guard let cuisine = RecipeCuisine(rawValue: cuisineRawData) else { return nil }
            cuisines.append(cuisine)
        }
        self.cuisines = cuisines
        
        var categories = [RecipeCategory]()
        for categoryRawData in categoriesRawData {
            guard let category = RecipeCategory(rawValue: categoryRawData) else { return nil }
            categories.append(category)
        }
        self.categories = categories
        
        var ingredients = [RecipeIngredientEntry]()
        for ingredientRawData in ingredientsRawData {
            guard
                let id = ingredientRawData[DatabaseDataSource.KeyName.id] as? String,
                let amount = ingredientRawData[DatabaseDataSource.KeyName.amount] as? CGFloat,
                let unitRawData = ingredientRawData[DatabaseDataSource.KeyName.unit] as? String,
                let unit = IngredientUnit(rawValue: unitRawData)
            else { return nil }
            ingredients.append(RecipeIngredientEntry(id: id, amount: amount, unit: unit))
        }
        self.ingredients = ingredients
    }
    init(id: RecipeID, name: String, subtitle: String, imageName: String, meals: [RecipeMeal], tags: [RecipeTag], cuisines: [RecipeCuisine], categories: [RecipeCategory], servings: Int, ingredients: [RecipeIngredientEntry], instructions: [String]) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.imageName = imageName
        self.meals = meals
        self.tags = tags
        self.cuisines = cuisines
        self.categories = categories
        self.servings = servings
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

enum RecipeTag: String {
    case tofu = "tofu"
    case meat = "meat"
    case fish = "fish"
    case vegan = "vegan"
    case noodles = "noodles"
    case rice = "rice"
    case chicken = "chicken"
    case pork = "pork"
    case beef = "beef"
    case sweet = "sweet"
    case spicy = "spicy"
    case savory = "savory"
    case riceBowl = "riceBowl"
    case deepFry = "deepFry"
    case panFry = "panFry"
    case microwaveOnly = "microwaveOnly"
    case stirFry = "stirFry"
    case steam = "steam"
    case stew = "stew"
    case teriyaki = "teriyaki"
    case salmon = "salmon"
    case mapo = "mapo"
    case bread = "bread"
    case seafood = "seafood"
}
enum RecipeCuisine: String {
    case america = "america"
    case chinese = "chinese"
    case taiwaneese = "taiwanese"
    case japanese = "japanese"
    case korean = "korean"
    case german = "german"
    case italian = "italian"
    case mexican = "mexican"
    case vietnamese = "vietnamese"
}
enum RecipeCategory: String {
    case mainCourse = "mainCourse"
    case sidedish = "sidedish"
    case hotpot = "hotpot"
    case drink = "drink"
    case snack = "snack"
    case dessert = "dessert"
    case soup = "soup"
    case bakery = "bakery"
}
enum RecipeMeal: String {
    case breakfast = "breakfast"
    case lunch = "lunch"
    case dinner = "dinner"
    case others = "others"
}

struct RecipeIngredientEntry {
    let id: IngredientID
    let amount: CGFloat
    let unit: IngredientUnit
}
