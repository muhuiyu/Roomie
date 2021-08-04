//
//  GroupMealsViewController.swift
//  Roomie
//
//  Created by Mu Yu on 31/7/21.
//

import UIKit
import Firebase

class GroupMealsViewController: ViewController {
    private var headerView = MealsTableHeaderView()
    
    private var tableView = UITableView()
    private var activityIndicatorView = UIActivityIndicatorView()
    
    private var dailyEntries = [[DailyMealsEntry]]() {
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
        
        database.fetchGroupMealPlan(from: startDate, to: endDate) { entries, error in
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
extension GroupMealsViewController {
    @objc
    private func didTapGrocery() {
        
    }
    private func didTapRandom() {
        
    }
}
// MARK: - View Config
extension GroupMealsViewController {
    private func configureViews() {
        title = "Group Meals"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Grocery", style: .plain, target: self, action: #selector(didTapGrocery))
        
        view.addSubview(activityIndicatorView)
        
        headerView.buttonText = "Create List"
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
extension GroupMealsViewController: UITableViewDataSource {
    private func printDate(viewForHeaderInSection section: Int) -> String? {
        return startDate.day(add: section).printWeekDayAndDay()
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
        if dailyEntries[section].count == 0 { return 1 }
        else { return dailyEntries[section].count }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dailyEntries[indexPath.section].count == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "No records yet"
            cell.textLabel?.textColor = UIColor.tertiaryLabel
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyMealsCell.reuseID, for: indexPath) as? DailyMealsCell else { return UITableViewCell() }

            let dayEntry = dailyEntries[indexPath.section][indexPath.row]
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
            cell.userName = database.getUserName(by: dayEntry.userID)
            cell.mealData = mealData
            return cell
        }
    }
}
// MARK: - Delegate
extension GroupMealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if dailyEntries[indexPath.section].count == 0 { return }
        else {
            let dailyEntry = dailyEntries[indexPath.section][indexPath.row]
            let viewController = DailyMealsPlanViewController(database: database, entry: dailyEntry, weekdayIndex: indexPath.section)
            viewController.delegate = self
            viewController.mode = .view
            viewController.title = dailyEntry.printWeekDayAndDayWithoutYear()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
// MARK: - Delegate from DailyMealsViewController
extension GroupMealsViewController: DailyMealsPlanViewControllerDelegate {
    func dailyMealsPlanViewController(_ controller: DailyMealsPlanViewController, requestToSave entry: DailyMealsEntry, at weekdayIndex: Int) {
//        dailyEntries[weekdayIndex] = entry
//        database.setMealPlans(with: [entry]) { error in
//            if let error = error {
//                print(error)
//                return
//            }
//        }
    }
}
