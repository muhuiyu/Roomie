//
//  SettingsViewController.swift
//  Roomie
//
//  Created by Mu Yu on 6/7/21.
//

import UIKit
import Firebase

class SettingsViewController: ViewController {
    private let tableView = UITableView()
    
    private let headerView = UIView()
    private let imageView = UIImageView()
    
    private let memberCell = UITableViewCell()
    
    private lazy var accountSettingsCells: [UITableViewCell] = [manageCalendarCell]
    private let manageCalendarCell = UITableViewCell()
    
    private let logoutCell = LinkCell()
    
    override init() {
        super.init()
        tabBarItem = UITabBarItem(title: "Settings",
                                  image: UIImage(systemName: "gearshape"),
                                  selectedImage: UIImage(systemName: "gearshape.fill"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCells()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LinkCell.self, forCellReuseIdentifier: LinkCell.reuseID)
        
        configureViews()
        configureGestures()
        configureConstraints()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.bounds.size = headerView.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: .greatestFiniteMagnitude))
    }
}
// MARK: - Actions
extension SettingsViewController {
    private func didTapLogout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        print("okay")
    }
}
// MARK: - View Config
extension SettingsViewController {
    private func configureCells() {
        logoutCell.linkText = "Log out"
        logoutCell.tapHandler = {[weak self] in
            self?.didTapLogout()
        }
    }
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
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1        // memberView
        case 1: return accountSettingsCells.count
        case 2: return 1
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return memberCell
        case 1: return accountSettingsCells[indexPath.row]
        case 2: return logoutCell
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

