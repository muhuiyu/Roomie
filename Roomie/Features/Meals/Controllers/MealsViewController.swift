//
//  MealsViewController.swift
//  Roomie
//
//  Created by Mu Yu on 11/7/21.
//

import UIKit

class MealsViewController: ViewController {
    private var tableView = UITableView()
    
    var meals: [[MealEntry]] = [
        [MealEntry(name: "My dinner", recipes: ["recipe-1"])],
        [MealEntry(name: "My dinner", recipes: ["recipe-2"])]
    ]
    
    override init() {
        super.init()
        tabBarItem = UITabBarItem(title: "Meals",
                                  image: UIImage(systemName: "circle"),
                                  selectedImage: UIImage(systemName: "circle.fill"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureViews()
        configureGestures()
        configureConstraints()
    }
}
// MARK: - Actions
extension MealsViewController {
    @objc
    private func didTapRecipes() {
        
    }
    private func didTapAddMeal(on date: Date) {
        
    }

}
// MARK: - View Config
extension MealsViewController {
    private func configureViews() {
        title = "Meals"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Recipes", style: .plain, target: self, action: #selector(didTapRecipes))
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
extension MealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Wednesday, Jun 29"
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return meals.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals[section].count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == meals[indexPath.section].count { // last row
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LinkCell.reuseID, for: indexPath) as? LinkCell
            else { return UITableViewCell() }
            cell.linkText = "+ Add meal"
            cell.tapHandler = {[weak self] in
                self?.didTapAddMeal(on: Date())
            }
            return cell
        }
        else {
            let cell = UITableViewCell()
            cell.textLabel?.text = meals[indexPath.section][indexPath.row].name
            return cell
        }
    }
}
// MARK: - Delegate
extension MealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
}

