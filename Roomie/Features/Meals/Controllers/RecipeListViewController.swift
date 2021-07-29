//
//  RecipeListViewController.swift
//  Roomie
//
//  Created by Mu Yu on 13/7/21.
//

import UIKit

class RecipeListViewController: ViewController {
    
    private let tableView = UITableView()
    
    private let database: DatabaseDataSource
    init(database: DatabaseDataSource) {
        self.database = database
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.reuseID)
        configureViews()
        configureGestures()
        configureConstraints()
    }
}
// MARK: - View Config
extension RecipeListViewController {
    private func configureViews() {
        title = "Recipes"
        view.addSubview(tableView)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        tableView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
// MARK: - Data Source
extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.allRecipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.reuseID, for: indexPath) as? RecipeCell else { return UITableViewCell() }
        cell.recipeEntry = database.allRecipes[indexPath.row]
        return cell
    }
}
// MARK: - Delegate
extension RecipeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? RecipeCell else { return }
        let viewController = RecipeDetailViewController()
        viewController.entry = cell.recipeEntry
        viewController.ingredientDictionary = database.ingredientDictionary
        navigationController?.pushViewController(viewController, animated: true)
    }
}

