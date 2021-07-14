//
//  DailyMealsEntry.swift
//  Roomie
//
//  Created by Mu Yu on 12/7/21.
//

import UIKit

typealias IngredientID = String
typealias RecipeID = String

struct DailyMealsEntry: Equatable, Comparable {
    let date: Date
    let meals: [MealEntry]
    
    static func < (lhs: DailyMealsEntry, rhs: DailyMealsEntry) -> Bool {
        return lhs.date < rhs.date
    }
    static func == (lhs: DailyMealsEntry, rhs: DailyMealsEntry) -> Bool {
        return lhs.date == rhs.date
    }
}
struct MealEntry {
    let name: String
    let recipes: [RecipeID]
}
