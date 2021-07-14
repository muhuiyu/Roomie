//
//  MessageTextCell.swift
//  Roomie
//
//  Created by Mu Yu on 6/7/21.
//

import UIKit

class MessageTextCell: UITableViewCell {
    
    static let reuseID = "MessageTextCell"
    
    private let messageContentView = MessageContentView()
    private let messageBubbleView = UIView()
    private let labelLabel = UILabel()
    
    var content: MessageContentTextEntry? {
        didSet {
            guard let content = content else { return }
            labelLabel.text = content.value
        }
    }
    var source: MessageCellSource? {
        didSet {
            switch source {
            case .me:
                labelLabel.textColor = UIColor.message.text.fromMe
                messageBubbleView.backgroundColor = UIColor.message.background.fromMe
                messageContentView.snp.remakeConstraints { make in
                    make.trailing.top.bottom.equalTo(contentView.layoutMarginsGuide)
                }
            case .other:
                labelLabel.textColor = UIColor.message.text.fromOther
                messageBubbleView.backgroundColor = UIColor.message.background.fromOther
                messageContentView.snp.remakeConstraints { make in
                    make.leading.top.bottom.equalTo(contentView.layoutMarginsGuide)
                }
            case .none:
                return
            }
        }
    }
    var entry: MessageEntry? {
        didSet {

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
extension MessageTextCell {
    private func configureViews() {
        labelLabel.numberOfLines = 0
        labelLabel.font = UIFont.small
        messageBubbleView.addSubview(labelLabel)
        messageBubbleView.layer.cornerRadius = Constants.message.cornerRadius
        messageContentView.contentView.addSubview(messageBubbleView)
        
        contentView.addSubview(messageContentView)
        contentView.backgroundColor = UIColor.secondarySystemBackground
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        labelLabel.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.spacing.small)
            make.leading.trailing.equalToSuperview().inset(Constants.spacing.medium)
        }
        messageBubbleView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        messageContentView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalTo(contentView.layoutMarginsGuide)
        }
    }
}
