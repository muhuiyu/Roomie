//
//  TextMessageView.swift
//  Roomie
//
//  Created by Mu Yu on 2/7/21.
//

import UIKit

class TextMessageView: UIView {
    private let textLabel = UILabel()
    
    var value: String? {
        get { return textLabel.text }
        set { textLabel.text = newValue }
    }
    var source: MessageCellSource? {
        didSet {
            switch source {
            case .me:
                textLabel.textColor = .white
            case .other:
                textLabel.textColor = .label
            case .none:
                return
            }
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
extension TextMessageView {
    private func configureViews() {
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.small
        addSubview(textLabel)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        textLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

