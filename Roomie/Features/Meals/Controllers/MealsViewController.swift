//
//  MealsViewController.swift
//  Roomie
//
//  Created by Mu Yu on 11/7/21.
//

import UIKit
import Firebase

class MealsViewController: ViewController {
    private var headerView = MealsTableHeaderView()
    
    private var tableView = UITableView()
    private var activityIndicatorView = UIActivityIndicatorView()
    
    private var dailyEntries = [DailyMealsEntry]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let database: DatabaseDataSource
    private let startDate: Date
    private let endDate: Date
    
    init(database: DatabaseDataSource, startDate: Date, endDate: Date) {
        self.database = database
        self.startDate = startDate
        self.endDate = endDate
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LinkCell.self, forCellReuseIdentifier: LinkCell.reuseID)
        tableView.register(DailyMealsCell.self, forCellReuseIdentifier: DailyMealsCell.reuseID)
        
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        tableView.isHidden = true
        
        configureViews()
        configureGestures()
        configureConstraints()
        
        database.fetchMealPlan(from: startDate, to: endDate) { entries, error in
            if let error = error {
                print(error)
                return
            }
            self.dailyEntries = entries
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.isHidden = true
            self.tableView.isHidden = false
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.bounds.size = headerView.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: .greatestFiniteMagnitude))
    }
}
// MARK: - Actions
extension MealsViewController {
    @objc
    private func didTapRecipes() {
        let viewController = RecipeListViewController(database: database)
        navigationController?.pushViewController(viewController, animated: true)
    }
    private func didTapAddMeal(on date: (Int, Int, Int), at weekdayIndex: Int) {
        guard
            let user = Auth.auth().currentUser,
            let group = database.currentGroupEntry
        else { return }
        
        let emptyEntry = DailyMealsEntry(userID: user.uid, groupID: group.id, year: date.0, month: date.1, day: date.2, meals: [
            MealEntry(name: "Breakfast", recipes: []),
            MealEntry(name: "Lunch", recipes: []),
            MealEntry(name: "Dinner", recipes: []),
            MealEntry(name: "Others", recipes: []),
        ])
        let viewController = DailyMealsPlanViewController(database: database, entry: emptyEntry, weekdayIndex: weekdayIndex)
        viewController.delegate = self
        viewController.mode = .edit
        viewController.title = emptyEntry.printWeekDayAndDayWithoutYear()
        navigationController?.pushViewController(viewController, animated: true)
    }
    private func didTapRandom() {
        
    }
}
// MARK: - View Config
extension MealsViewController {
    private func configureViews() {
        title = "Meals"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Recipes", style: .plain, target: self, action: #selector(didTapRecipes))
        
        view.addSubview(activityIndicatorView)
        
        headerView.buttonText = "Randomize my week"
        headerView.date = startDate.printDayWithoutYear() + " - " + endDate.printDayWithoutYear()
        headerView.tapHandler = {[weak self] in
            self?.didTapRandom()
        }
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        tableView.snp.remakeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        activityIndicatorView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
// MARK: - Data Source
extension MealsViewController: UITableViewDataSource {
    private func printDate(viewForHeaderInSection section: Int) -> String? {
        let dailyEntry = dailyEntries[section]
        
        var dateComponents = DateComponents()
        dateComponents.year = dailyEntry.year
        dateComponents.month = dailyEntry.month
        dateComponents.day = dailyEntry.day
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        let calendar = Calendar(identifier: .gregorian)
        guard let date = calendar.date(from: dateComponents) else { return nil }
        return date.printWeekDayAndDay()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TableSectionHeaderView()
        view.text = printDate(viewForHeaderInSection: section)
        view.isTextBold = true
        view.isButtonHidden = true
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dailyEntries.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dayEntry = dailyEntries[indexPath.section]
        
        if dayEntry.isMealEmpty() {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LinkCell.reuseID, for: indexPath) as? LinkCell else { return UITableViewCell() }
            cell.linkText = "+ Add meal"
            cell.tapHandler = {[weak self] in
                self?.didTapAddMeal(on: (dayEntry.year, dayEntry.month, dayEntry.day), at: indexPath.section)
            }
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyMealsCell.reuseID, for: indexPath) as? DailyMealsCell else { return UITableViewCell() }

            var mealData = [(String, String)]()     // mealName, mealList
            for meal in dayEntry.meals {
                if meal.recipes.count == 0 { continue }
                
                var recipeNames = [String]()
                for recipe in meal.recipes {
                    guard let recipeName = self.database.recipeDictionary[recipe] else { continue }
                    recipeNames.append(recipeName.name)
                }
                mealData.append((meal.name, recipeNames.joined(separator: ", ")))
            }
            cell.clearStack()
            cell.mealData = mealData
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
        let dailyEntry = dailyEntries[indexPath.section]
        let viewController = DailyMealsPlanViewController(database: database, entry: dailyEntry, weekdayIndex: indexPath.section)
        viewController.delegate = self
        viewController.mode = .edit
        viewController.title = dailyEntry.printWeekDayAndDayWithoutYear()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
// MARK: - Delegate from DatabaseDataSource
extension MealsViewController: DatabaseDataSourceDelegate {
    func databaseDataSourceGroupEntryDidChange(_ database: DatabaseDataSource) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
// MARK: - Delegate from DailyMealsViewController
extension MealsViewController: DailyMealsPlanViewControllerDelegate {
    func dailyMealsPlanViewController(_ controller: DailyMealsPlanViewController, requestToSave entry: DailyMealsEntry, at weekdayIndex: Int) {
        dailyEntries[weekdayIndex] = entry
        database.setMealPlans(with: [entry]) { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
}
