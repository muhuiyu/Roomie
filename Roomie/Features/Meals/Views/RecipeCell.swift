//
//  RecipeCell.swift
//  Roomie
//
//  Created by Mu Yu on 25/7/21.
//

import UIKit

class RecipeCell: UITableViewCell {
    static let reuseID = "RecipeCell"
    
    var recipeEntry: RecipeEntry? {
        didSet {
            guard let entry = recipeEntry else { return }
            textLabel?.text = entry.name
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureGestures()
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - View Config
extension RecipeCell {
    private func configureViews() {
        
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        
    }
}
