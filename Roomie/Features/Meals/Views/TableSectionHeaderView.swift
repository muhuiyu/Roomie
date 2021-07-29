//
//  TableSectionHeaderView.swift
//  Roomie
//
//  Created by Mu Yu on 27/7/21.
//

import UIKit

class TableSectionHeaderView: UIView {
    private let textLabel = UILabel()
    private let actionButton = RoundButton(icon: UIImage(systemName: "plus")!, buttonColor: .clear, iconColor: UIColor.systemBlue)
    
    var text: String? {
        get { return textLabel.text }
        set { textLabel.text = newValue }
    }
    var isTextBold: Bool = true {
        didSet {
            textLabel.font = isTextBold ? UIFont.bodyHeavy : UIFont.body
        }
    }
    var buttonIcon: UIImage? {
        didSet {
            actionButton.icon = buttonIcon
        }
    }
    var isButtonHidden = false {
        didSet {
            actionButton.isHidden = isButtonHidden
        }
    }
    var buttonTapHandler: (() -> Void)? {
        didSet {
            actionButton.tapHandler = buttonTapHandler
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
extension TableSectionHeaderView {
    private func configureViews() {
        textLabel.textColor = UIColor.label
        textLabel.font = isTextBold ? UIFont.bodyHeavy : UIFont.body
        addSubview(textLabel)
        addSubview(actionButton)
        backgroundColor = UIColor.systemGroupedBackground
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        textLabel.snp.remakeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide).inset(Constants.spacing.small)
            make.top.bottom.equalTo(layoutMarginsGuide).inset(Constants.spacing.slight)
            make.trailing.equalTo(actionButton.snp.leading)
        }
        actionButton.snp.remakeConstraints { make in
            make.size.equalTo(Constants.iconButtonSize.trivial)
            make.trailing.equalTo(layoutMarginsGuide).inset(Constants.spacing.small)
            make.centerY.equalToSuperview()
        }
    }
}

