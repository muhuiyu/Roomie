//
//  RecipeDetailInstructionCell.swift
//  Roomie
//
//  Created by Mu Yu on 26/7/21.
//

import UIKit

class RecipeDetailInstructionCell: UITableViewCell {
    static let reuseID = "RecipeDetailInstructionCell"
    
    private let numberLabel = UILabel()
    private let contentLabel = UILabel()
    
    var number: String? {
        get { return numberLabel.text }
        set { numberLabel.text = newValue }
    }
    var content: String? {
        get { return contentLabel.text }
        set { contentLabel.text = newValue }
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
// MARK: - View Config
extension RecipeDetailInstructionCell {
    private func configureViews() {
        numberLabel.textColor = UIColor.label
        numberLabel.font = UIFont.bodyHeavy
        contentView.addSubview(numberLabel)
        
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.label
        contentLabel.font = UIFont.body
        contentView.addSubview(contentLabel)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        numberLabel.snp.remakeConstraints { make in
            make.leading.equalTo(contentView.layoutMarginsGuide).inset(Constants.spacing.small)
            make.trailing.equalTo(contentLabel.snp.leading)
            make.top.equalTo(contentLabel)
        }
        contentLabel.snp.remakeConstraints { make in
            make.top.bottom.trailing.equalTo(contentView.layoutMarginsGuide).inset(Constants.spacing.small)
            make.leading.equalTo(contentView.layoutMarginsGuide).inset(Constants.spacing.enormous)
        }
    }
}
