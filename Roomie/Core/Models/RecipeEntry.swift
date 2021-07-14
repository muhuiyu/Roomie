//
//  RecipeEntry.swift
//  Roomie
//
//  Created by Mu Yu on 12/7/21.
//

import UIKit

struct RecipeEntry {
    let id: RecipeID
    let name: String
    let imageName: String
    let servings: Int
    let ingredients: [RecipeIngredientEntry]
    let instructions: [String]
}
struct RecipeIngredientEntry {
    let id: IngredientID
    let amount: Int
//    let unit:
}
