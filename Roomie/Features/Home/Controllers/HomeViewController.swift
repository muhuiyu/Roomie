//
//  HomeViewController.swift
//  Roomie
//
//  Created by Mu Yu on 2/7/21.
//

import UIKit

class HomeViewController: ViewController {
    private let tableView = UITableView()
    private let eaterMealPlanCell = HomeMealPlanCardCell()
    private lazy var cells: [[UITableViewCell]] = [[], [eaterMealPlanCell]] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let database: DatabaseDataSource
    private let isNextWeekMealPlanAvailable = Date().isToday(weekDay: 7)    // last day of the week
    
    init(database: DatabaseDataSource) {
        self.database = database
        super.init()
        tabBarItem = UITabBarItem(title: "Home",
                                  image: UIImage(systemName: "house"),
                                  selectedImage: UIImage(systemName: "house.fill"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.isUserInteractionEnabled = true
        tableView.register(HomeMealPlanCardCell.self, forCellReuseIdentifier: HomeMealPlanCardCell.reuseID)
    
        configureCells()
        configureViews()
        configureGestures()
        configureConstraints()
    }
}
// MARK: - Actions
extension HomeViewController {
    private func didTapEaterMealPlan() {
        let startDate = Date().sundayInThisWeek()
        let endDate = startDate.day(after: 6).noon
        let viewController = MealsViewController(database: database, startDate: startDate, endDate: endDate)
        navigationController?.pushViewController(viewController, animated: true)
    }
    private func didTapGroupMealPlan() {
        let startDate = Date().sundayInThisWeek()
        let endDate = startDate.day(after: 6).noon
        if !database.isUserGroupCook() { return }
        let viewController = GroupMealsViewController(database: database, startDate: startDate, endDate: endDate)
        navigationController?.pushViewController(viewController, animated: true)
    }
    private func didTapSetMealPlanForNextWeek() {
        let startDate = Date().sundayInThisWeek().day(after: 7)
        let endDate = startDate.day(after: 6).noon
        let viewController = MealsViewController(database: database, startDate: startDate, endDate: endDate)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
// MARK: - View Config
extension HomeViewController {
    private func configureCells() {
        if isNextWeekMealPlanAvailable {
            let newPlanReminderCell = FullWidthBannerCell()
            newPlanReminderCell.title = "Time to plan your meal!"
            newPlanReminderCell.image = UIImage(named: "banner-meal-plan")
            newPlanReminderCell.buttonText = "Plan Now"
            newPlanReminderCell.buttonTapHandler = {[weak self] in
                self?.didTapSetMealPlanForNextWeek()
            }
            cells[0].append(newPlanReminderCell)
        }

        eaterMealPlanCell.title = "Weekly meal plan"
        eaterMealPlanCell.subtitle = "Check your meal plan this week"
        eaterMealPlanCell.image = UIImage(named: "banner-meal-plan")
        eaterMealPlanCell.tapHandler = {[weak self] in
            self?.didTapEaterMealPlan()
        }
        
        if database.isUserGroupCook() {
            let cookMealPlanCell = HomeMealPlanCardCell()
            cookMealPlanCell.title = "Group meal plan"
            cookMealPlanCell.subtitle = "Check your group meal plan for the week"
            cookMealPlanCell.image  = UIImage(named: "banner-meal-plan")
            cookMealPlanCell.tapHandler = {[weak self] in
                self?.didTapGroupMealPlan()
            }
            cells[1].append(cookMealPlanCell)
        }
    }
    private func configureViews() {
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.separatorStyle = .none
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
extension HomeViewController: UITableViewDataSource {
    private struct HomeConstants {
        static let mealPlanSection = 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TableSectionHeaderView()
        view.isButtonHidden = true
        view.backgroundColor = .clear
        view.textFont = UIFont.h3
        switch section {
            case HomeConstants.mealPlanSection: view.text = "Meal Plan"
            default: view.text = ""
        }
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
// MARK: - Delegate
extension HomeViewController: UITableViewDelegate {

}

