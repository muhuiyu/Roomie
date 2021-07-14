//
//  MessageContentView.swift
//  Roomie
//
//  Created by Mu Yu on 6/7/21.
//

import UIKit

class MessageContentView: UIView {
    
//    private let avatarView = UIView()
//    private let accessoryView = UIView()
    
    let contentView = UIView()
    
    override init(frame: CGRect) {
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
extension MessageContentView {
    private func configureViews() {
        addSubview(contentView)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
