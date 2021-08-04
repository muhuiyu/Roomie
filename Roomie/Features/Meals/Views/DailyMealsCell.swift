//
//  DailyMealsCell.swift
//  Roomie
//
//  Created by Mu Yu on 28/7/21.
//

import UIKit

class DailyMealsCell: UITableViewCell {
    static let reuseID = "DailyMealsCell"
    private let stackView = UIStackView()
    
    var userName: String? {
        didSet {
            let label = UILabel()
            label.text = userName
            label.font = UIFont.bodyHeavy
            label.textColor = UIColor.label.withAlphaComponent(0.8)
            label.numberOfLines = 0
            stackView.insertArrangedSubview(label, at: 0)
        }
    }
    var mealData: [(String, String)] = [] {
        didSet {
            for data in mealData {
                let label = UILabel()
                label.text = "・" + data.0 + ": " + data.1
                label.font = UIFont.body
                label.textColor = UIColor.label.withAlphaComponent(0.8)
                label.numberOfLines = 0
                stackView.addArrangedSubview(label)
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureGestures()
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK: - Actions
extension DailyMealsCell {
    func clearStack() {
        stackView.removeAllArrangedSubviews()
    }
}
// MARK: - View Config
extension DailyMealsCell {
    private func configureViews() {
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing.small
        stackView.alignment = .leading
        contentView.addSubview(stackView)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        stackView.snp.remakeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
    }
}
