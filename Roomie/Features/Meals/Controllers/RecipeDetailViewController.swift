//
//  RecipeDetailViewController.swift
//  Roomie
//
//  Created by Mu Yu on 26/7/21.
//

import UIKit
import Kingfisher
import FirebaseStorage

class RecipeDetailViewController: ViewController {
    
    private let headerView = RecipeDetailHeaderView()
    private let tableView = UITableView()
    
    var ingredientDictionary = [IngredientID: IngredientEntry]()
    
    var entry: RecipeEntry? {
        didSet {
            guard let entry = entry else { return }
            headerView.title = entry.name
            headerView.subtitle = entry.subtitle
            headerView.imageStoragePath = entry.imageStoragePath
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LabelDetailCell.self, forCellReuseIdentifier: LabelDetailCell.reuseID)
        tableView.register(RecipeDetailInstructionCell.self, forCellReuseIdentifier: RecipeDetailInstructionCell.reuseID)
        
        configureViews()
        configureGestures()
        configureConstraints()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.bounds.size = headerView.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: .greatestFiniteMagnitude))
    }
}
// MARK: - View Config
extension RecipeDetailViewController {
    private func configureViews() {
        title = ""
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
extension RecipeDetailViewController: UITableViewDataSource {
    private struct Sections {
        static let ingredient = 0
        static let instruction = 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TableSectionHeaderView()
        view.isButtonHidden = true
        switch section {
        case Sections.ingredient: view.text = "Ingredients"
        case Sections.instruction: view.text = "Instructions"
        default: return nil
        }
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let entry = entry else { return 0 }
        switch section {
        case Sections.ingredient: return entry.ingredients.count
        case Sections.instruction: return entry.instructions.count
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Sections.ingredient:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: LabelDetailCell.reuseID, for: indexPath) as? LabelDetailCell,
                let entry = entry,
                let ingredientName = ingredientDictionary[entry.ingredients[indexPath.row].id]?.name
            else { return UITableViewCell() }
            
            let ingredientRef = entry.ingredients[indexPath.row]
            cell.label = ingredientName
            cell.value = ingredientRef.amount.description + " " + DatabaseDataSource.unitTranslation(as: ingredientRef.unit)
            return cell
        case Sections.instruction:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailInstructionCell.reuseID, for: indexPath) as? RecipeDetailInstructionCell else { return UITableViewCell() }
            cell.content = entry?.instructions[indexPath.row]
            cell.number = String(indexPath.row)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
// MARK: - Delegate
extension RecipeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

