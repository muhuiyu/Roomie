//
//  MealsTableHeaderView.swift
//  Roomie
//
//  Created by Mu Yu on 27/7/21.
//

import UIKit

class MealsTableHeaderView: UIView {
    private var dateLabel = UILabel()
    private var actionButton = TextButton(frame: .zero, buttonType: .secondary)
    
    var date: String? {
        get { return dateLabel.text }
        set { dateLabel.text = newValue }
    }
    var tapHandler: (() -> Void)? {
        didSet {
            actionButton.tapHandler = tapHandler
        }
    }
    var buttonText: String? {
        didSet {
            actionButton.text = buttonText
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureViews()
        configureGestures()
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - View Config
extension MealsTableHeaderView {
    private func configureViews() {
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont.body
        dateLabel.textColor = UIColor.secondaryLabel
        addSubview(dateLabel)
        actionButton.buttonHeight = 32
        actionButton.textFont = UIFont.smallBold
        addSubview(actionButton)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        dateLabel.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.spacing.medium)
            make.top.equalToSuperview()
        }
        actionButton.snp.remakeConstraints { make in
            make.leading.equalTo(dateLabel)
            make.width.equalTo(160)
            make.top.equalTo(dateLabel.snp.bottom).offset(Constants.spacing.small)
            make.bottom.equalToSuperview().inset(Constants.spacing.medium)
        }
    }
}

