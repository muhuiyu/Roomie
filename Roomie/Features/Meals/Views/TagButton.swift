//
//  TagButton.swift
//  Roomie
//
//  Created by Mu Yu on 8/8/21.
//

import UIKit

class TagButton: UIView {
    
    private let textLabel = UILabel()
    private let containerView = UIView()
    private let arrowButton = RoundButton(icon: UIImage(systemName: "chevron.down")!, buttonColor: .clear, iconColor: UIColor.brand.primary)
    
    var buttonType: ButtonType {
        didSet {
            configureButtons()
        }
    }
    
    enum ButtonType {
        case primary
        case secondary
        case text
    }
    
    var text: String? {
        get { return textLabel.text }
        set { textLabel.text = newValue }
    }
    var textColor: UIColor? {
        didSet {
            textLabel.textColor = textColor
            arrowButton.iconColor = textColor
        }
    }
    var textFont: UIFont? {
        didSet {
            textLabel.font = textFont
        }
    }
    var buttonHeight: CGFloat = 24 {
        didSet {
            containerView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(buttonHeight)
            }
        }
    }
    var buttonColor: UIColor? {
        didSet {
            switch buttonType {
                case .primary:
                    containerView.backgroundColor = buttonColor
                case .secondary:
                    textLabel.textColor = buttonColor
                    arrowButton.iconColor = buttonColor
                    containerView.layer.borderColor = buttonColor?.cgColor
                case .text:
                    textLabel.textColor = buttonColor
                    arrowButton.iconColor = buttonColor
            }
        }
    }
    var isEnable: Bool = true {
        didSet {
            if isEnable {
                layer.opacity = 1
            }
            else {
                layer.opacity = 0.4
            }
        }
    }
    
    var tapHandler: (() -> Void)?
    
    init(frame: CGRect = .zero, buttonType: ButtonType = .primary) {
        self.buttonType = buttonType
        super.init(frame: frame)
        configureViews()
        configureButtons()
        configureGestures()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Actions
extension TagButton {
    @objc
    private func didTapButton() {
        if isEnable { tapHandler?() }
    }
}
// MARK: - View Config
extension TagButton {
    private func configureViews() {
        textLabel.font = UIFont.small
        textLabel.textAlignment = .left
        containerView.addSubview(textLabel)
        
        containerView.addSubview(arrowButton)
        containerView.layer.cornerRadius = Constants.textButton.cornerRadius
        addSubview(containerView)
    }
    private func configureButtons() {
        switch buttonType {
        case .primary:
            textLabel.textColor = UIColor.basic.light
            arrowButton.iconColor = UIColor.basic.light
            containerView.backgroundColor = UIColor.brand.primary
        case .secondary:
            textLabel.textColor = UIColor.brand.primary
            arrowButton.iconColor = UIColor.brand.primary
            containerView.backgroundColor = .clear
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.brand.primary.cgColor
        case .text:
            textLabel.textColor = UIColor.brand.primary
            arrowButton.iconColor = UIColor.brand.primary
            containerView.backgroundColor = .clear
        }
    }
    private func configureGestures() {
        let tapRecoginier = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        addGestureRecognizer(tapRecoginier)
    }
    private func configureConstraints() {
        textLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.spacing.small)
            make.trailing.equalTo(arrowButton.snp.leading).offset(-Constants.spacing.small)
        }
        arrowButton.snp.remakeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(Constants.spacing.small)
            make.size.equalTo(Constants.iconButtonSize.trivial)
        }
        containerView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(buttonHeight)
        }
    }
}
