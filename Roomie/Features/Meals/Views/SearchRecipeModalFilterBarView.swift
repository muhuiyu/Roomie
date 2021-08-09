//
//  SearchRecipeModalFilterView.swift
//  Roomie
//
//  Created by Mu Yu on 8/8/21.
//

import UIKit

class SearchRecipeModalFilterBarView: UIView {
    
    private let filterButton = RoundButton(icon: UIImage(systemName: "slider.horizontal.3")!, buttonColor: UIColor.tertiarySystemBackground, iconColor: UIColor.label)
    private let tagSelectButton = TagButton(frame: .zero, buttonType: .primary)
    private let separatorView = SeparatorView()
    
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
extension SearchRecipeModalFilterBarView {
    private func configureViews() {
        backgroundColor = .white
        addSubview(filterButton)
        
        tagSelectButton.text = "Tag"
        tagSelectButton.buttonColor = UIColor.tertiarySystemBackground
        addSubview(tagSelectButton)
        addSubview(separatorView)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        filterButton.snp.remakeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide).inset(Constants.spacing.trivial)
            make.top.bottom.equalTo(layoutMarginsGuide).inset(Constants.spacing.small)
            make.size.equalTo(Constants.iconButtonSize.medium)
        }
        tagSelectButton.snp.remakeConstraints { make in
            make.leading.equalTo(filterButton.snp.trailing).offset(Constants.spacing.small)
            make.top.bottom.equalTo(filterButton)
        }
        separatorView.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

