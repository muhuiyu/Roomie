//
//  GroupEntry.swift
//  Roomie
//
//  Created by Mu Yu on 28/7/21.
//

import UIKit

typealias UserID = String
typealias GroupID = String

struct GroupEntry {
    var id: GroupID
    var name: String
    var users: [userEntry]
    var cookID: UserID
}

struct userEntry {
    let id: UserID
    let name: String
}
