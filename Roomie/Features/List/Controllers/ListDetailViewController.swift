//
//  ListDetailViewController.swift
//  Roomie
//
//  Created by Mu Yu on 6/7/21.
//

import UIKit

class ListDetailViewController: ViewController {
    
    private let tableView = UITableView()
    
    private let listEntry: ListEntry
    init(listEntry: ListEntry) {
        self.listEntry = listEntry
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LinkCell.self, forCellReuseIdentifier: LinkCell.reuseID)
        
        configureViews()
        configureGestures()
        configureConstraints()
    }
}
// MARK: - Actions
extension ListDetailViewController {
    @objc
    private func didTapSave() {
        print("didTapSave")
    }
    @objc
    private func didTapPin() {
        print("didTapPin")
    }
    private func didTapAddItem() {
        
    }

}
// MARK: - View Config
extension ListDetailViewController {
    private func configureViews() {
        title = listEntry.name
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave)),
            UIBarButtonItem(image: UIImage(systemName: "pin")!, style: .plain, target: self, action: #selector(didTapPin))
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
extension ListDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listEntry.items.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == listEntry.items.count {
            let cell = LinkCell()
            cell.linkText = "+ Add item"
            cell.tapHandler = {[weak self] in
                self?.didTapAddItem()
            }
            return cell
        }
        else {
            let cell = UITableViewCell()
            cell.textLabel?.text = listEntry.items[indexPath.row].value
            return cell
        }
    }
}
// MARK: - Delegate
extension ListDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        print(indexPath)
    }
}

