//
//  SearchRecipeModalViewController.swift
//  Roomie
//
//  Created by Mu Yu on 27/7/21.
//

import UIKit

protocol SearchRecipeModalViewControllerDelegate: AnyObject {
    func searchRecipeModalViewController(_ controller: SearchRecipeModalViewController, didSelectItem item: RecipeEntry, for mealIndex: Int)
    func searchRecipeModalViewController(_ controller: SearchRecipeModalViewController, didSelectItem item: RecipeEntry, toReplaceAt indexPath: IndexPath)
    func searchRecipeModalViewControllerDidRequestDismiss(_ controller: SearchRecipeModalViewController)
}

class SearchRecipeModalViewController: ViewController {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    // start filtering
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    private var filteredData: [RecipeEntry] = []
    // End filtering
    
    private var emptyStateItems = [String: [RecipeEntry]]()
    private var items: [RecipeEntry] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var searchBarPlaceholder: String? {
        didSet {
            guard let searchBarPlaceholder = searchBarPlaceholder else { return }
            searchController.searchBar.placeholder = searchBarPlaceholder
        }
    }
    var previousSelectedIndexpath: IndexPath?
    
    private let database: DatabaseDataSource
    private let selectedMealIndex: Int
    
    weak var delegate: SearchRecipeModalViewControllerDelegate?

    init(database: DatabaseDataSource, selectedMealIndex: Int) {
        self.database = database
        self.selectedMealIndex = selectedMealIndex
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configureViews()
        configureConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
// MARK: - Actions
extension SearchRecipeModalViewController {
    private struct FileConstants {
        static let breakfast = 0
        static let lunch = 1
        static let dinner = 2
        static let other = 3
    }
    private func configureItems() {
        switch selectedMealIndex {
        case FileConstants.breakfast: items = self.database.getAllRecipes(asMeal: .breakfast)
        case FileConstants.lunch: items = self.database.getAllRecipes(asMeal: .lunch)
        case FileConstants.dinner: items = self.database.getAllRecipes(asMeal: .dinner)
        case FileConstants.other: items = self.database.allRecipes
        default: return
        }
    }
    private func filterContentForSearchText(_ searchText: String) {
        self.filteredData = self.database.allRecipes.filter({ (item: RecipeEntry) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        })
        items = self.filteredData
    }
//    private func requestSearchResult(with searchText: String) {
//        self.items = self.database.allRecipes.filter({ (item: RecipeEntry) -> Bool in
//            return item.name.lowercased().contains(searchText.lowercased())
//        })
//    }
    @objc
    private func didTapDismiss() {
        delegate?.searchRecipeModalViewControllerDidRequestDismiss(self)
    }
    @objc
    private func didTapSuggestion() {
        
    }
}
// MARK: - View Config
extension SearchRecipeModalViewController {
    private func configureViews() {
        title = "Add Dish"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Suggest", style: .plain, target: self, action: #selector(didTapSuggestion))
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        view.addSubview(tableView)
    }
    private func configureConstraints() {
        tableView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
// MARK: - Data Source
extension SearchRecipeModalViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let filterBarView = SearchRecipeModalFilterBarView()
//            filterBarView.delegate = self
            return filterBarView
        }
        else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: .none)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        
        var tags = [String]()
        for tag in item.tags { tags.append("#" + tag.rawValue) }
        cell.detailTextLabel?.text = tags.joined(separator: " ")
        cell.detailTextLabel?.textColor = UIColor.secondaryLabel
        return cell
    }
}
// MARK: - Delegate
extension SearchRecipeModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if let previousSelectedIndexpath = previousSelectedIndexpath {
            delegate?.searchRecipeModalViewController(self, didSelectItem: items[indexPath.row], toReplaceAt: previousSelectedIndexpath)
        }
        else {
            delegate?.searchRecipeModalViewController(self, didSelectItem: items[indexPath.row], for: selectedMealIndex)
        }
    }
}
// MARK: - Search Result
extension SearchRecipeModalViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !isSearchBarEmpty {
            let searchBar = searchController.searchBar
            filterContentForSearchText(searchBar.text!)
//            requestSearchResult(with: searchBar.text!)
        }
        else {
            self.items = self.database.allRecipes
        }
    }
}
