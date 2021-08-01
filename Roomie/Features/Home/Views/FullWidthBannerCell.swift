//
//  FullWidthBannerCell.swift
//  Roomie
//
//  Created by Mu Yu on 31/7/21.
//

import UIKit

class FullWidthBannerCell: UITableViewCell {
    static let reuseID = "FullWidthBannerCell"
    
    private let bannerView = UIImageView()
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let button = TextButton(frame: .zero, buttonType: .primary)
    
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
    var cardBackgroundColor: UIColor = UIColor.systemBackground {
        didSet {
            backgroundColor = cardBackgroundColor
        }
    }
    var buttonTapHandler: (() -> Void)? {
        didSet {
            button.tapHandler = buttonTapHandler
        }
    }
    var buttonText: String? {
        didSet {
            button.text = buttonText
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
// MARK: - View Config
extension FullWidthBannerCell {
    private func configureViews() {
        bannerView.contentMode = .scaleAspectFill
        bannerView.clipsToBounds = true
        contentView.addSubview(bannerView)
        
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.h3
        stackView.addArrangedSubview(titleLabel)
        
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = UIColor.label
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.small
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.addArrangedSubview(subtitleLabel)
        stackView.axis = .vertical
        stackView.spacing = Constants.spacing.small
        stackView.alignment = .center
        contentView.addSubview(stackView)
        
        contentView.addSubview(button)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        bannerView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(Constants.imageSize.fitScreen)
            make.height.equalTo(120)
        }
        stackView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(contentView.layoutMarginsGuide)
            make.centerX.equalToSuperview()
            make.top.equalTo(bannerView.snp.bottom).offset(Constants.spacing.medium)
        }
        button.snp.remakeConstraints { make in
//            make.leading.trailing.equalTo(stackView)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.spacing.medium)
            make.bottom.equalTo(contentView.layoutMarginsGuide).inset(Constants.spacing.enormous)
        }
    }
}
