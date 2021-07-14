//
//  HomeViewController.swift
//  Roomie
//
//  Created by Mu Yu on 2/7/21.
//

import UIKit

class HomeViewController: ViewController {
    private let tableView = UITableView()
    
    override init() {
        super.init()
        tabBarItem = UITabBarItem(title: "Home",
                                  image: UIImage(systemName: "house"),
                                  selectedImage: UIImage(systemName: "house.fill"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureGestures()
        configureConstraints()
    }
}
// MARK: - View Config
extension HomeViewController {
    private func configureViews() {
        title = "Home"
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        
    }
}

