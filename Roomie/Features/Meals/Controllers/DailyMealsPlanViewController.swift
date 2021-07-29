//
//  DailyMealsPlanViewController.swift
//  Roomie
//
//  Created by Mu Yu on 25/7/21.
//

import UIKit
import Firebase

protocol DailyMealsPlanViewControllerDelegate: AnyObject {
    func dailyMealsPlanViewController(_ controller: DailyMealsPlanViewController, requestToSave entry: DailyMealsEntry, at weekdayIndex: Int)
//    func dailyMealsPlanViewControllerDidRequestDismiss(_ controller: DailyMealsPlanViewController)
}

class DailyMealsPlanViewController: ViewController {
    
    private let tableView = UITableView()
    
    private let database: DatabaseDataSource
    private var entry: DailyMealsEntry {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let weekdayIndex: Int
    
    weak var delegate: DailyMealsPlanViewControllerDelegate?
    
    init(database: DatabaseDataSource, entry: DailyMealsEntry, weekdayIndex: Int) {
        self.database = database
        self.entry = entry
        self.weekdayIndex = weekdayIndex
        super.init()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LinkCell.self, forCellReuseIdentifier: LinkCell.reuseID)
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.reuseID)
            
        configureViews()
        configureGestures()
        configureConstraints()
    }
}
// MARK: - Actions
extension DailyMealsPlanViewController {
    func scrollTo(indexOfMealAt section: Int) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
    }
    private func getRecipeIDList() -> [RecipeID] {
        var recipeIDsList = Set<String>()
        for meal in entry.meals {
            meal.recipes.forEach { recipeIDsList.insert($0) }
        }
        return Array(recipeIDsList)
    }
}
// MARK: - View Config
extension DailyMealsPlanViewController {
    private func configureViews() {
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
// MARK: - Actions
extension DailyMealsPlanViewController {
    private func didTapAddMeal(at mealIndex: Int) {
        let viewController = SearchRecipeModalViewController(database: database)
        viewController.delegate = self
        viewController.selectedMealIndex = mealIndex
        present(viewController.embedInNavgationController(), animated: true) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
// MARK: - Data Source
extension DailyMealsPlanViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return entry.meals.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return entry.meals[section].name
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TableSectionHeaderView()
        let mealEntry = entry.meals[section]
        
        view.text = mealEntry.name
        view.isTextBold = true
        view.isButtonHidden = mealEntry.recipes.isEmpty ? true : false
        view.buttonTapHandler = {[weak self] in
            self?.didTapAddMeal(at: section)
        }
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entry.meals[section].recipes.isEmpty ? 1 : entry.meals[section].recipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mealEntry = entry.meals[indexPath.section]
        if mealEntry.recipes.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LinkCell.reuseID, for: indexPath) as? LinkCell else { return UITableViewCell() }
            cell.linkText = "+ Add meal"
            cell.tapHandler = {[weak self] in
                self?.didTapAddMeal(at: indexPath.section)
            }
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.reuseID, for: indexPath) as? RecipeCell else { return UITableViewCell() }
            let recipeID = entry.meals[indexPath.section].recipes[indexPath.row]
            let recipeEntry = database.recipeDictionary[recipeID]
            cell.textLabel?.text = recipeEntry?.name
            cell.recipeEntry = recipeEntry
            return cell
        }
    }
}
// MARK: - Delegate
extension DailyMealsPlanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        guard
            let cell = tableView.cellForRow(at: indexPath) as? RecipeCell,
            let recipeEntry = cell.recipeEntry
        else { return }
        
        var ingredientsID = [String]()
        for ingredientRef in recipeEntry.ingredients { ingredientsID.append(ingredientRef.id) }
        
        self.database.updateIngredientDictionary(with: ingredientsID) { error in
            if let error = error {
                print(error)
                return
            }
            let viewController = RecipeDetailViewController()
            viewController.entry = cell.recipeEntry
            viewController.ingredientDictionary = self.database.ingredientDictionary
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.entry.meals[indexPath.section].recipes.remove(at: indexPath.row)
            self.delegate?.dailyMealsPlanViewController(self, requestToSave: self.entry, at: self.weekdayIndex)
        }
    }
}
// MARK: - Delegate from SearchRecipeModalViewController
extension DailyMealsPlanViewController: SearchRecipeModalViewControllerDelegate {
    func searchRecipeModalViewController(_ controller: SearchRecipeModalViewController, didSelectItem item: RecipeEntry, for mealIndex: Int) {
        self.dismiss(animated: true) {
            self.entry.meals[mealIndex].recipes.append(item.id)
            self.delegate?.dailyMealsPlanViewController(self, requestToSave: self.entry, at: self.weekdayIndex)
        }
    }
    func searchRecipeModalViewControllerDidRequestDismiss(_ controller: SearchRecipeModalViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
