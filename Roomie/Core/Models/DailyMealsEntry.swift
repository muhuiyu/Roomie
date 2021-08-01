//
//  DailyMealsEntry.swift
//  Roomie
//
//  Created by Mu Yu on 12/7/21.
//

import UIKit
import Firebase

typealias IngredientID = String
typealias RecipeID = String

struct DailyMealsEntry: Equatable, Comparable {
    let userID: UserID
    let groupID: GroupID
    let year: Int
    let month: Int
    let day: Int
    var meals: [MealEntry]
    
    func isMealEmpty() -> Bool {
        if meals.isEmpty { return true }
        for meal in meals {
            if !meal.recipes.isEmpty { return false }
        }
        return true
    }
    
    func printWeekDayAndDayWithoutYear() -> String {
        var dateComponents = DateComponents()
        dateComponents.year = self.year
        dateComponents.month = self.month
        dateComponents.day = self.day
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        let calendar = Calendar(identifier: .gregorian)
        guard let date = calendar.date(from: dateComponents) else { return "" }
        return date.printWeekDayAndDayWithoutYear()
    }
    
    init(userID: UserID, groupID: GroupID, year: Int, month: Int, day: Int, meals: [MealEntry]) {
        self.userID = userID
        self.groupID = groupID
        self.year = year
        self.month = month
        self.day = day
        self.meals = meals
    }
    
    static func < (lhs: DailyMealsEntry, rhs: DailyMealsEntry) -> Bool {
        var lhsDateComponents = DateComponents()
        lhsDateComponents.year = lhs.year
        lhsDateComponents.month = lhs.month
        lhsDateComponents.day = lhs.day
        lhsDateComponents.timeZone = TimeZone(abbreviation: "UTC")
        lhsDateComponents.hour = 0
        lhsDateComponents.minute = 0
        
        var rhsDateComponents = DateComponents()
        rhsDateComponents.year = rhs.year
        rhsDateComponents.month = rhs.month
        rhsDateComponents.day = rhs.day
        rhsDateComponents.timeZone = TimeZone(abbreviation: "UTC")
        rhsDateComponents.hour = 0
        rhsDateComponents.minute = 0
        
        let calendar = Calendar(identifier: .gregorian)
        guard
            let lhsDate = calendar.date(from: lhsDateComponents),
            let rhsDate = calendar.date(from: rhsDateComponents)
        else { return false }
        
        return lhsDate < rhsDate
    }
    static func == (lhs: DailyMealsEntry, rhs: DailyMealsEntry) -> Bool {
        var lhsDateComponents = DateComponents()
        lhsDateComponents.year = lhs.year
        lhsDateComponents.month = lhs.month
        lhsDateComponents.day = lhs.day
        lhsDateComponents.timeZone = TimeZone(abbreviation: "UTC")
        lhsDateComponents.hour = 0
        lhsDateComponents.minute = 0
        
        var rhsDateComponents = DateComponents()
        rhsDateComponents.year = rhs.year
        rhsDateComponents.month = rhs.month
        rhsDateComponents.day = rhs.day
        rhsDateComponents.timeZone = TimeZone(abbreviation: "UTC")
        rhsDateComponents.hour = 0
        rhsDateComponents.minute = 0
        
        let calendar = Calendar(identifier: .gregorian)
        guard
            let lhsDate = calendar.date(from: lhsDateComponents),
            let rhsDate = calendar.date(from: rhsDateComponents)
        else { return false }
        
        return lhsDate == rhsDate
    }
}
struct MealEntry {
    var name: String
    var recipes: [RecipeID]
    
    init?(document: DocumentSnapshot) {
        guard
            let data = document.data(),
            let name = data[DatabaseDataSource.KeyName.name] as? String,
            let recipes = data[DatabaseDataSource.KeyName.recipes] as? [String]
        else { return nil }
        self.name = name
        self.recipes = recipes
    }
    init(name: String, recipes: [RecipeID]) {
        self.name = name
        self.recipes = recipes
    }
}
