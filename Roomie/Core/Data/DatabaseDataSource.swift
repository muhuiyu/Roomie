//
//  DatabaseDataSource.swift
//  Roomie
//
//  Created by Mu Yu on 13/7/21.
//

import UIKit
import Firebase

class DatabaseDataSource: NSObject {
    
    private(set) var recipeDictionary = [RecipeID: RecipeEntry]()
    private(set) var ingredientDictionary = [IngredientID: IngredientEntry]()
    private(set) var allRecipes = [RecipeEntry]()
    private(set) var allIngredients = [IngredientEntry]()
    
    private(set) var currentGroupID = "baj3tAjA3m7r2jT8scPG"    // banh mi
    
    struct CollectionName {
        static let chat = "chat"
        static let ingredients = "ingredients"
        static let meals = "meals"
        static let recipes = "recipes"
        static let groups = "groups"
    }
    struct KeyName {
        static let userID = "userID"
        static let groupID = "groupID"
        static let year = "year"
        static let month = "month"
        static let day = "day"
        static let meals = "meals"
        static let name = "name"
        static let subtitle = "subtitle"
        static let imageName = "imageName"
        static let recipes = "recipes"
        static let id = "id"
        static let tags = "tags"
        static let cuisines = "cuisines"
        static let categories = "categories"
        static let servings = "servings"
        static let ingredients = "ingredients"
        static let instructions = "instructions"
        static let amount = "amount"
        static let unit = "unit"
        static let availableUnits = "availableUnits"
        
    }
    enum FirebaseError: Error {
        case snapshotMissing
        case multipleDocumentUsingSameID
        case dataKeyMissing
        case entryInitFailure
        case userMissing
        case documentMissing
    }
}
// MARK: - Setup
extension DatabaseDataSource {
    func setup(callback: @escaping (_ error: Error?) -> Void) {
        self.downloadAllRecipes { error in
            if let error = error {
                return callback(error)
            }
            self.downloadAllIngredients { error in
                if let error = error {
                    return callback(error)
                }
                return callback(nil)
            }
        }
    }
    func fetchUserGroup(callback: @escaping(_ isHouseholdExist: Bool, _ error: Error?) -> Void) {
        
    }
}
// MARK: - Translation / Wordings
extension DatabaseDataSource {
    static func unitTranslation(as unit: IngredientUnit) -> String {
        let UnitList: [IngredientUnit:String] = [
            .each: "each",
            .gram: "g",
            .kilogram: "kg",
            .milliliter: "mL",
            .liter: "L",
            .teaspoon: "tsp",
            .tablespoon: "tbsp"
        ]
        guard let string = UnitList[unit] else { return "" }
        return string
    }
}
// MARK: - Actions
extension DatabaseDataSource {
    func updateRecipeDictionary(with recipeIDs: [RecipeID], callback: @escaping(_ error: Error?) -> Void) {
        self.fetchRecipes(ids: recipeIDs) { recipes, error in
            if let error = error {
                print(error)
                return callback(error)
            }
            for recipe in recipes { self.recipeDictionary[recipe.id] = recipe }
            return callback(nil)
        }
    }
    func updateIngredientDictionary(with ingredientIDs: [IngredientID], callback: @escaping(_ error: Error?) -> Void) {
        self.fetchIngredients(ids: ingredientIDs) { ingredients, error in
            if let error = error {
                print(error)
                return callback(error)
            }
            for ingredient in ingredients { self.ingredientDictionary[ingredient.id] = ingredient }
            return callback(nil)
        }
    }
    func downloadAllRecipes(callback: @escaping(_ error: Error?) -> Void) {
        self.fetchAllRecipes { recipes, error in
            if let error = error {
                print(error)
                return callback(error)
            }
            self.allRecipes = recipes
            for recipe in recipes { self.recipeDictionary[recipe.id] = recipe }
            return callback(nil)
        }
    }
    func downloadAllIngredients(callback: @escaping(_ error: Error?) -> Void) {
        self.fetchAllIngredients { ingredients, error in
            if let error = error {
                print(error)
                return callback(error)
            }
            self.allIngredients = ingredients
            for ingredient in ingredients { self.ingredientDictionary[ingredient.id] = ingredient }
            return callback(nil)
        }
    }
    func findMostLovedRecipes(callback: @escaping(_ recipes: [RecipeEntry], _ error: Error?) -> Void) {
        
    }
}
// MARK: - To Firebase data
extension DatabaseDataSource {
    private func toFirestoreData(from entry: DailyMealsEntry) -> [String: Any] {
        var data = [String: Any]()
        var mealData = [[String: Any]]()
        for meal in entry.meals {
            mealData.append([
                "name": meal.name,
                "recipes": meal.recipes
            ])
        }
        data[KeyName.userID] = entry.userID
        data[KeyName.groupID] = entry.groupID
        data[KeyName.year] = entry.year
        data[KeyName.month] = entry.month
        data[KeyName.day] = entry.day
        data[KeyName.meals] = mealData
        return data
    }
    private func toFirestoreData(from entry: RecipeEntry) -> [String: Any] {
        var data = [String: Any]()
        var mealsData = [String]()
        for meal in entry.meals { mealsData.append(meal.rawValue) }
        var tagsData = [String]()
        for tag in entry.tags { tagsData.append(tag.rawValue) }
        var cuisinesData = [String]()
        for cuisine in entry.cuisines { cuisinesData.append(cuisine.rawValue) }
        var categoriesData = [String]()
        for category in entry.categories { categoriesData.append(category.rawValue) }
        
        var ingredientsData = [[String: Any]]()
        for ingredient in entry.ingredients {
            ingredientsData.append([
                "id": ingredient.id,
                "amount": ingredient.amount,
                "unit": ingredient.unit.rawValue
            ])
        }
        
        data[KeyName.name] = entry.name
        data[KeyName.subtitle] = entry.subtitle
        data[KeyName.imageName] = entry.imageName
        data[KeyName.meals] = mealsData
        data[KeyName.tags] = tagsData
        data[KeyName.cuisines] = cuisinesData
        data[KeyName.categories] = categoriesData
        data[KeyName.servings] = entry.servings
        data[KeyName.ingredients] = ingredientsData
        data[KeyName.instructions] = entry.instructions
        return data
    }
    private func toFirestoreData(from entry: IngredientEntry) -> [String: Any] {
        var data = [String: Any]()
        var unitData = [String]()
        for unit in entry.availableUnits { unitData.append(unit.rawValue) }
        
        data[KeyName.name] = entry.name
        data[KeyName.availableUnits] = unitData
        return data
    }
}
// MARK: - Write
extension DatabaseDataSource {
    func setIngredients(with ingredients: [IngredientEntry], callback: @escaping (_ error: Error?) -> Void) {
        let ref = Firestore.firestore().collection(CollectionName.ingredients)
        let group = DispatchGroup()
        for entry in ingredients {
            let ingredientRef = ref.document(entry.id)
            let data = toFirestoreData(from: entry)
            
            group.enter()
            ingredientRef.setData(data, merge: true) { error in
                if let error = error { return callback(error) }
                print(entry.id)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("all ingredients written")
            return callback(nil)
        }
    }
    func setRecipes(with recipes: [RecipeEntry], callback: @escaping (_ error: Error?) -> Void) {
        let ref = Firestore.firestore().collection(CollectionName.recipes)
        let group = DispatchGroup()
        for entry in recipes {
            let recipeRef = ref.document(entry.id)
            let data = toFirestoreData(from: entry)
            
            group.enter()
            recipeRef.setData(data, merge: true) { error in
                if let error = error { return callback(error) }
                print(entry.id)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("all recipes written")
            return callback(nil)
        }
    }
    func setMealPlans(with plans: [DailyMealsEntry], callback: @escaping (_ error: Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return callback(FirebaseError.userMissing) }
        
        let ref = Firestore.firestore().collection(CollectionName.meals)
        let group = DispatchGroup()
        for entry in plans {
            let data = toFirestoreData(from: entry)
            
            let id = user.uid + "-" + self.currentGroupID + "-" + String(entry.year) + String(entry.month) + String(entry.day)
            ref.document(id).setData(data) { error in
                if let error = error { return callback(error) }
            }
        }
        group.notify(queue: .main) {
            print("all meal plans written")
            return callback(nil)
        }
    }
}

// MARK: - Fetch
extension DatabaseDataSource {
    func fetchMeals(on date: (Int, Int, Int), callback: @escaping (_ meals: [MealEntry], _ error: Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return callback([], FirebaseError.userMissing) }
        
        let ref = Firestore.firestore().collection(CollectionName.meals)
        ref.whereField(KeyName.groupID, isEqualTo: self.currentGroupID).whereField(KeyName.userID, isEqualTo: user.uid).whereField(KeyName.year, isEqualTo: date.0).whereField(KeyName.month, isEqualTo: date.1).whereField(KeyName.day, isEqualTo: date.2).getDocuments { snapshot, error in
            if let error = error { return callback([], error) }
            guard let snapshot = snapshot else { return }
            
            if snapshot.count > 1 { return callback([], FirebaseError.multipleDocumentUsingSameID) }
            if snapshot.isEmpty { return callback([], nil) }
            
            let data = snapshot.documentChanges[0].document.data()
            guard let mealsRawData = data[KeyName.meals] as? [[String : Any]] else { return callback([], FirebaseError.dataKeyMissing) }
            
            var meals = [MealEntry]()
            for mealRawData in mealsRawData {
                guard
                    let mealName = mealRawData[KeyName.name] as? String,
                    let mealRecipes = mealRawData[KeyName.recipes] as? [String]
                else { return callback([], FirebaseError.dataKeyMissing) }
                meals.append(MealEntry(name: mealName, recipes: mealRecipes))
            }
            return callback(meals, nil)
        }
    }
    func fetchMealPlan(from startDate: Date, to endDate: Date, callback: @escaping(_ entries: [DailyMealsEntry], _ error: Error?) -> Void) {
        guard let user = Auth.auth().currentUser else { return callback([], FirebaseError.userMissing) }
        
        let group = DispatchGroup()
        var entries = [DailyMealsEntry]()
        
        var dateList = [Date]()
        var currentDate = startDate
        while currentDate <= endDate {
            dateList.append(currentDate)
            currentDate = currentDate.dayAfter
        }
        
        for date in dateList {
            group.enter()

            self.fetchMeals(on: (date.year, date.month, date.dayOfMonth)) { meals, error in
                if let error = error { return callback([], error) }
                entries.append(DailyMealsEntry(userID: user.uid, groupID: self.currentGroupID, year: date.year, month: date.month, day: date.dayOfMonth, meals: meals))
                group.leave()
            }
        }
        group.notify(queue: .main) {
            entries.sort { leftEntry, rightEntry in
                return leftEntry < rightEntry
            }
            print("fetched meal plan")
            return callback(entries, nil)
        }
    }
    func fetchRecipe(id: RecipeID, callback: @escaping(_ entry: RecipeEntry?, _ error: Error?) -> Void) {
        let ref = Firestore.firestore().collection(CollectionName.recipes)
        ref.document(id).getDocument { snapshot, error in
            if let error = error { return callback(nil, error) }
            guard let snapshot = snapshot else { return callback(nil, FirebaseError.snapshotMissing) }
            guard let entry = RecipeEntry(document: snapshot) else { return callback(nil, FirebaseError.entryInitFailure) }
            return callback(entry, nil)
        }
    }
    private func fetchRecipes(ids: [RecipeID], callback: @escaping(_ recipes: [RecipeEntry], _ error: Error?) -> Void) {
        let ref = Firestore.firestore().collection(CollectionName.recipes)
        ref.whereField(.documentID(), in: ids).getDocuments { snapshot, error in
            if let error = error { return callback([], error) }
            guard let snapshot = snapshot else { return callback([], FirebaseError.snapshotMissing) }

            var recipes = [RecipeEntry]()
            for change in snapshot.documentChanges {
                if change.type == .added {
                    guard let recipe = RecipeEntry(document: change.document) else { continue }
                    recipes.append(recipe)
                }
            }
            return callback(recipes, nil)
        }
    }
    private func fetchAllRecipes(callback: @escaping(_ recipes: [RecipeEntry], _ error: Error?) -> Void) {
        let ref = Firestore.firestore().collection(CollectionName.recipes)
        ref.getDocuments { snapshot, error in
            if let error = error { return callback([], error) }
            guard let snapshot = snapshot else { return callback([], FirebaseError.snapshotMissing) }

            var recipes = [RecipeEntry]()
            for change in snapshot.documentChanges {
                if change.type == .added {
                    guard let recipe = RecipeEntry(document: change.document) else { continue }
                    recipes.append(recipe)
                }
            }
            return callback(recipes, nil)
        }
    }
    private func fetchIngredients(ids: [IngredientID], callback: @escaping(_ ingredients: [IngredientEntry], _ error: Error?) -> Void) {
        let ref = Firestore.firestore().collection(CollectionName.ingredients)
        var batches = [[String]]()
        for _ in 0..<(ids.count / 10) { batches.append([]) }
        if ids.count % 10 > 0 { batches.append([]) }
        
        for (i, id) in ids.enumerated() {
            let category = i/10
            batches[category].append(id)
        }
        
        let group = DispatchGroup()
        var ingredients = [IngredientEntry]()
        
        for batch in batches {
            group.enter()
            ref.whereField(.documentID(), in: batch).getDocuments { snapshot, error in
                if let error = error { return callback([], error) }
                guard let snapshot = snapshot else { return callback([], FirebaseError.snapshotMissing) }

                for change in snapshot.documentChanges {
                    if change.type == .added {
                        guard let ingredient = IngredientEntry(document: change.document) else { continue }
                        ingredients.append(ingredient)
                    }
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            return callback(ingredients, nil)
        }
    }
    private func fetchAllIngredients(callback: @escaping(_ ingredients: [IngredientEntry], _ error: Error?) -> Void) {
        let ref = Firestore.firestore().collection(CollectionName.ingredients)
        ref.getDocuments { snapshot, error in
            if let error = error { return callback([], error) }
            guard let snapshot = snapshot else { return callback([], FirebaseError.snapshotMissing) }

            var ingredients = [IngredientEntry]()
            for change in snapshot.documentChanges {
                if change.type == .added {
                    guard let ingredient = IngredientEntry(document: change.document) else { continue }
                    ingredients.append(ingredient)
                }
            }
            return callback(ingredients, nil)
        }
    }
}
