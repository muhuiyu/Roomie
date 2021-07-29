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
    
    private var startDate = Date()
    private var endDate = Date()
    private var dailyEntries = [DailyMealsEntry]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let database: DatabaseDataSource
    
    init(database: DatabaseDataSource) {
        self.database = database
        super.init()
        tabBarItem = UITabBarItem(title: "Meals",
                                  image: UIImage(systemName: "circle"),
                                  selectedImage: UIImage(systemName: "circle.fill"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDate = Date().sundayInThisWeek()
        endDate = startDate.day(after: 6).noon
        
        database.fetchMealPlan(from: startDate, to: endDate) { entries, error in
            if let error = error {
                print(error)
                return
            }
            self.dailyEntries = entries
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.register(LinkCell.self, forCellReuseIdentifier: LinkCell.reuseID)
            self.tableView.register(DailyMealsCell.self, forCellReuseIdentifier: DailyMealsCell.reuseID)
            
            self.configureViews()
            self.configureGestures()
            self.configureConstraints()
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
        guard let user = Auth.auth().currentUser else { return }
        
        let emptyEntry = DailyMealsEntry(userID: user.uid, groupID: database.currentGroupID, year: date.0, month: date.1, day: date.2, meals: [
            MealEntry(name: "Breakfast", recipes: []),
            MealEntry(name: "Lunch", recipes: []),
            MealEntry(name: "Dinner", recipes: []),
            MealEntry(name: "Others", recipes: []),
        ])
        let viewController = DailyMealsPlanViewController(database: database, entry: emptyEntry, weekdayIndex: weekdayIndex)
        viewController.delegate = self
        viewController.title = emptyEntry.printWeekDayAndDayWithoutYear()
        navigationController?.pushViewController(viewController, animated: true)
    }
    private func getRecipeIDList(from entries: [DailyMealsEntry]) -> [RecipeID] {
        var recipeIDsList = Set<String>()
        for dailyEntry in entries {
            for meal in dailyEntry.meals {
                meal.recipes.forEach { recipeIDsList.insert($0) }
            }
        }
        return Array(recipeIDsList)
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
            make.edges.equalToSuperview()
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
        
        if dayEntry.meals.isEmpty {
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
        viewController.title = dailyEntry.printWeekDayAndDayWithoutYear()
        navigationController?.pushViewController(viewController, animated: true)
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
