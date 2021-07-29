//
//  MealsTableHeaderView.swift
//  Roomie
//
//  Created by Mu Yu on 27/7/21.
//

import UIKit

class MealsTableHeaderView: UIView {
    private var dateLabel = UILabel()
    private var randomButton = TextButton(frame: .zero, buttonType: .secondary)
    
    var date: String? {
        get { return dateLabel.text }
        set { dateLabel.text = newValue }
    }
    var tapHandler: (() -> Void)? {
        didSet {
            randomButton.tapHandler = tapHandler
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
        randomButton.text = "Randomize my week"
        randomButton.buttonHeight = 32
        randomButton.textFont = UIFont.smallBold
        addSubview(randomButton)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        dateLabel.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.spacing.medium)
            make.top.equalToSuperview()
        }
        randomButton.snp.remakeConstraints { make in
            make.leading.equalTo(dateLabel)
            make.width.equalTo(160)
            make.top.equalTo(dateLabel.snp.bottom).offset(Constants.spacing.small)
            make.bottom.equalToSuperview().inset(Constants.spacing.medium)
        }
    }
}

