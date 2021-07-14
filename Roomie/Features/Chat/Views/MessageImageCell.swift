//
//  MessageImageCell.swift
//  Roomie
//
//  Created by Mu Yu on 7/7/21.
//

import UIKit

class MessageImageCell: UITableViewCell {
    
    static let reuseID = "MessageImageCell"
    
    private let messageContentView = MessageContentView()
    private let messageBubbleView = UIView()
    private let imageItemView = UIImageView()
    
    var content: MessageContentImageEntry? {
        didSet {
            guard let content = content else { return }
            imageItemView.image = UIImage(named: content.imageURL)
        }
    }
    var source: MessageCellSource? {
        didSet {
            switch source {
            case .me:
                messageContentView.snp.remakeConstraints { make in
                    make.trailing.top.bottom.equalTo(contentView.layoutMarginsGuide)
                }
            case .other:
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
extension MessageImageCell {
    private func configureViews() {
        imageItemView.contentMode = .scaleAspectFit
        messageBubbleView.addSubview(imageItemView)
        messageBubbleView.backgroundColor = .none
        messageBubbleView.layer.cornerRadius = Constants.message.cornerRadius
        messageContentView.contentView.addSubview(messageBubbleView)
        
        contentView.addSubview(messageContentView)
        contentView.backgroundColor = UIColor.secondarySystemBackground
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        imageItemView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.lessThanOrEqualTo(Constants.imageSize.cover)
        }
        messageBubbleView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        messageContentView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalTo(contentView.layoutMarginsGuide)
        }
    }
}

