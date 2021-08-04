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
    private let database: DatabaseDataSource
    
    var searchBarPlaceholder: String? {
        didSet {
            guard let searchBarPlaceholder = searchBarPlaceholder else { return }
            searchController.searchBar.placeholder = searchBarPlaceholder
        }
    }
    var selectedMealIndex: Int = 0
    var previousSelectedIndexpath: IndexPath?

    weak var delegate: SearchRecipeModalViewControllerDelegate?

    init(database: DatabaseDataSource) {
        self.database = database
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = self.database.allRecipes
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.configureViews()
        self.configureConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
// MARK: - Actions
extension SearchRecipeModalViewController {
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
