//
//  IngredientEntry.swift
//  Roomie
//
//  Created by Mu Yu on 25/7/21.
//

import UIKit
import Firebase

struct IngredientEntry {
    let id: IngredientID
    let name: String
    let availableUnits: [IngredientUnit]
    
    init? (document: DocumentSnapshot) {
        self.id = document.documentID
        guard
            let data = document.data(),
            let name = data[DatabaseDataSource.KeyName.name] as? String,
            let availableUnitsRawData = data[DatabaseDataSource.KeyName.availableUnits] as? [String]
        else { return nil }
        
        var units = [IngredientUnit]()
        for rawData in availableUnitsRawData {
            guard let unit = IngredientUnit(rawValue: rawData) else { continue }
            units.append(unit)
        }
        self.name = name
        self.availableUnits = units
    }
    init(id: IngredientID, name: String, availableUnits: [IngredientUnit]) {
        self.id = id
        self.name = name
        self.availableUnits = availableUnits
    }
}

enum IngredientUnit: String {
    case kilogram = "kilogram"
    case gram = "gram"
    case each = "each"
    case slice = "slice"
    case cube = "cube"
    case pack = "pack"
    case teaspoon = "teaspoon"
    case tablespoon = "tablespoon"
    case liter = "liter"
    case milliliter = "milliliter"
}
