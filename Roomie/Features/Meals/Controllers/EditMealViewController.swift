//
//  EditMealViewController.swift
//  Roomie
//
//  Created by Mu Yu on 27/7/21.
//

import UIKit

class EditMealViewController: ViewController {
    
    private let tableView = UITableView()
    
    private let mealNameCell = TextInputCell()
    private lazy var cells: [UITableViewCell] = [mealNameCell]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureGestures()
        configureConstraints()
    }
}
// MARK: - View Config
extension EditMealViewController {
    private func configureViews() {
        
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        
    }
}

