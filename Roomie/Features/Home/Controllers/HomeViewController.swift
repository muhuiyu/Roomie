//
//  HomeViewController.swift
//  Roomie
//
//  Created by Mu Yu on 2/7/21.
//

import UIKit

class HomeViewController: ViewController {
    private let tableView = UITableView()
    private let cardView = CardImageTitleSubtitleButton()
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        cardView.title = "title"
        cardView.subtitle = "hello"
        cardView.image = UIImage(systemName: "add")
        view.addSubview(cardView)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        cardView.snp.remakeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.height.equalTo(120)
        }
    }
}

