//
//  RecipeDetailHeaderView.swift
//  Roomie
//
//  Created by Mu Yu on 26/7/21.
//

import UIKit

class RecipeDetailHeaderView: UIView {
    private let bannerView = UIImageView()
    private let titleLabel = UILabel()
    private let addToPlanButton = TextButton(frame: .zero, buttonType: .primary)
    private let subtitleLabel = UILabel()
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var subtitle: String? {
        get { return subtitleLabel.text }
        set { subtitleLabel.text = newValue }
    }
    var image: UIImage? {
        get { return bannerView.image }
        set { bannerView.image = newValue }
    }
    var tapHandler: (() -> Void)? {
        didSet {
            addToPlanButton.tapHandler = tapHandler
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
// MARK: - Actions
extension RecipeDetailHeaderView {

}
// MARK: - View Config
extension RecipeDetailHeaderView {
    private func configureViews() {
        bannerView.contentMode = .scaleAspectFill
        bannerView.clipsToBounds = true
        addSubview(bannerView)
        
        titleLabel.font = UIFont.h3
        titleLabel.textColor = UIColor.label
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        subtitleLabel.font = UIFont.small
        subtitleLabel.textColor = UIColor.secondaryLabel
        subtitleLabel.numberOfLines = 0
        addSubview(subtitleLabel)
        
        addToPlanButton.text = "+ Add to plan"
        addSubview(addToPlanButton)

    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        bannerView.snp.remakeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.width.equalTo(Constants.imageSize.fitScreen)
//            make.height.equalTo(bannerView.snp.width).multipliedBy(0.5)
            make.height.lessThanOrEqualTo(300)
        }
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(Constants.spacing.large)
            make.leading.trailing.equalTo(layoutMarginsGuide).inset(Constants.spacing.small)
        }
        subtitleLabel.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.spacing.medium)
        }
        addToPlanButton.snp.remakeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.spacing.medium)
            make.height.equalTo(36)
            make.width.equalTo(150)
            make.bottom.equalTo(layoutMarginsGuide).inset(Constants.spacing.medium)
        }
    }
}

