//
//  ListViewController.swift
//  Roomie
//
//  Created by Mu Yu on 6/7/21.
//

import UIKit

class ListViewController: ViewController {
    private let tableView = UITableView()
    
    var shoppingLists: [ListEntry] = [
        ListEntry(name: "Durgstore", items: []),
        ListEntry(name: "Grocery", items: [
            ListItemEntry(value: "chicken", isCompleted: true),
            ListItemEntry(value: "fish", isCompleted: false)
        ])
    ]
    
    override init() {
        super.init()
        tabBarItem = UITabBarItem(title: "List",
                                  image: UIImage(systemName: "list.bullet"),
                                  selectedImage: UIImage(systemName: "list.bullet.indent"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configureViews()
        configureGestures()
        configureConstraints()
    }
}
// MARK: - Actions
extension ListViewController {
    @objc
    private func didTapAdd() {
        print("didTapAdd")
    }
}
// MARK: - View Config
extension ListViewController {
    private func configureViews() {
        title = "List"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd)),
        ]
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
extension ListViewController: UITableViewDataSource {
    private struct Section {
        static let shoppingList = 0
        static let others = 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.shoppingList:
            return "Shopping List"
        case Section.others:
            return "Others"
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.shoppingList:
            return shoppingLists.count
        case Section.others:
            return 2
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.shoppingList:
            let cell = UITableViewCell()
            cell.textLabel?.text = shoppingLists[indexPath.row].name
            cell.detailTextLabel?.text = String(shoppingLists[indexPath.row].items.count)
            return cell
        case Section.others:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}
// MARK: - Delegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        switch indexPath.section {
        case Section.shoppingList:
            let viewController = ListDetailViewController(listEntry: shoppingLists[indexPath.row])
            navigationController?.pushViewController(viewController, animated: true)
        case Section.others:
            print("second")
        default:
            return
        }
    }
}

