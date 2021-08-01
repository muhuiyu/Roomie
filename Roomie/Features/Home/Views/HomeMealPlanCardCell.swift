//
//  HomeMealPlanCardCell.swift
//  Roomie
//
//  Created by Mu Yu on 30/7/21.
//

import UIKit

class HomeMealPlanCardCell: UITableViewCell {
    static let reuseID = "HomeMealPlanCardCell"
    private let cardView = CardFullWidth()
    private let tapView = UIView()
    
    var title: String? {
        didSet {
            cardView.title = title
        }
    }
    var subtitle: String? {
        didSet {
            cardView.subtitle = subtitle
        }
    }
    var image: UIImage? {
        didSet {
            cardView.image = image
        }
    }
    var tapHandler: (() -> Void)?
    
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
extension HomeMealPlanCardCell {
    @objc
    private func didTapCell() {
        self.tapHandler?()
    }
}
// MARK: - View Config
extension HomeMealPlanCardCell {
    private func configureViews() {
        cardView.backgroundColor = UIColor.secondarySystemBackground
        contentView.addSubview(cardView)
        contentView.addSubview(tapView)
    }
    private func configureGestures() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        tapView.addGestureRecognizer(tapRecognizer)
    }
    private func configureConstraints() {
        cardView.snp.remakeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide)
            make.height.equalTo(120)
        }
        tapView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
