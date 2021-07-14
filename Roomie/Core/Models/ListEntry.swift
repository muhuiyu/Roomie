//
//  ListEntry.swift
//  Roomie
//
//  Created by Mu Yu on 6/7/21.
//

import UIKit

struct ListEntry {
    let name: String
    let items: [ListItemEntry]
}

struct ListItemEntry {
    let value: String
    let isCompleted: Bool
}
