//
//  MessageCell.swift
//  Roomie
//
//  Created by Mu Yu on 2/7/21.
//

import UIKit

//class MessageCell: UITableViewCell {
//    static let reuseID = "MessageCell"
//
//    let container = UIView()
//
//    var source: MessageCellSource = .me {
//        didSet {
//            reconfigureStyle()
//        }
//    }
//
//    var content: MessageContent? = nil {
//
//    }
//
//
//    var entry: MessageEntry? {
//        didSet {
//            reconfigureMessageContent()
//        }
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureViews()
//        configureGestures()
//        configureConstraints()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//// MARK: - View Config
//extension MessageCell {
//    private func configureViews() {
//        container.layer.cornerRadius = Constants.message.cornerRadius
//        contentView.addSubview(container)
//    }
//    private func configureConstraints() {
//
//    }
//    private func reconfigureMessageContent() {
//        guard let content = content else { return }
//        switch content {
//        case let .text(textEntry):
//            let messageView = TextMessageView()
//            messageView.value = textEntry.value
//            container.addSubview(messageView)
//            messageView.snp.remakeConstraints { make in
//                make.edges.equalTo(container).inset(Constants.spacing.small)
//            }
//        case .image:
//            guard let content = entry.content as? MessageContentImageEntry else { return }
//            let messageView = ImageMessageView()
//            messageView.image = UIImage(named: content.imageURL)
//            container.addSubview(messageView)
//            messageView.snp.remakeConstraints { make in
//                make.edges.equalTo(container).inset(Constants.spacing.small)
//            }
//        default: return
//        }
//    }
//    private func reconfigureStyle() {
//        switch source {
//        case .me:
//            container.backgroundColor = UIColor.message.background.fromMe
//            container.snp.remakeConstraints { make in
//                make.top.bottom.trailing.equalTo(contentView.layoutMarginsGuide)
//            }
//        case .other:
//            container.backgroundColor = UIColor.message.background.fromOther
//            container.snp.remakeConstraints { make in
//                make.top.bottom.leading.equalTo(contentView.layoutMarginsGuide)
//            }
//        }
//    }
//    private func configureGestures() {
//
//    }
//}
