//
//  SettingsViewController.swift
//  Roomie
//
//  Created by Mu Yu on 6/7/21.
//

import UIKit

class SettingsViewController: ViewController {
    private let tableView = UITableView()
    
    private let headerView = UIView()
    private let imageView = UIImageView()
    
    private let memberCell = UITableViewCell()
    
    private lazy var accountSettingsCells: [UITableViewCell] = [manageCalendarCell]
    private let manageCalendarCell = UITableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
extension SettingsViewController {
    private func configureViews() {
        imageView.image = UIImage(named: "cover.jpeg")
        imageView.contentMode = .scaleAspectFill
        headerView.addSubview(imageView)
        
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
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1        // memberView
        case 1: return accountSettingsCells.count
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return memberCell
        case 1: return accountSettingsCells[indexPath.row]
        default: return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Account Settings"
        }
        return nil
    }
}
// MARK: - Delegate
extension SettingsViewController: UITableViewDelegate {
    
}

