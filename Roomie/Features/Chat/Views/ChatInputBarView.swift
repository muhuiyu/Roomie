//
//  ChatInputBarView.swift
//  Roomie
//
//  Created by Mu Yu on 7/7/21.
//

import UIKit

class ChatInputBarView: UIView {
    private let separatorView = UIView()
    private let textField = CustomTextField()
    private let addButton = RoundButton(icon: UIImage(systemName: "plus")!, buttonColor: .clear, iconColor: UIColor.secondaryLabel)
    private let cameraButton = RoundButton(icon: UIImage(systemName: "camera")!, buttonColor: .clear, iconColor: UIColor.secondaryLabel)
    private let microphoneButton = RoundButton(icon: UIImage(systemName: "mic")!, buttonColor: .clear, iconColor: UIColor.secondaryLabel)
    
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
// MARK: - Actions
extension ChatInputBarView {
    private func didTapAdd() {
        print("tap add")
    }
    private func didTapSticker() {
        print("tap sticker")
    }
    private func didTapCamera() {
        print("tap camera")
    }
    private func didTapMicrophone() {
        print("tap microphone")
    }
}
// MARK: - View Config
extension ChatInputBarView {
    private func configureViews() {
        separatorView.backgroundColor = UIColor.secondarySystemBackground
        addSubview(separatorView)
        
        addButton.tapHandler = {[weak self] in
            self?.didTapAdd()
        }
        addSubview(addButton)
        textField.placeholderText = "Message..."
        textField.icon = UIImage(systemName: "face.smiling")
        textField.delegate = self
        textField.cornerRadius = 16
        addSubview(textField)
        
        cameraButton.tapHandler = {[weak self] in
            self?.didTapCamera()
        }
        addSubview(cameraButton)
        
        microphoneButton.tapHandler = {[weak self] in
            self?.didTapMicrophone()
        }
        addSubview(microphoneButton)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        separatorView.snp.remakeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.top.equalToSuperview()
        }
        addButton.snp.remakeConstraints { make in
            make.size.equalTo(Constants.iconButtonSize.medium)
            make.top.bottom.equalTo(textField)
            make.leading.equalTo(layoutMarginsGuide)
        }
        textField.snp.remakeConstraints { make in
            make.top.bottom.equalTo(layoutMarginsGuide).inset(Constants.spacing.trivial)
            make.height.equalTo(50)
            make.leading.equalTo(addButton.snp.trailing).offset(Constants.spacing.small)
            make.trailing.equalTo(cameraButton.snp.leading).offset(-Constants.spacing.small)
        }
        cameraButton.snp.remakeConstraints { make in
            make.size.equalTo(addButton)
            make.top.bottom.equalTo(textField)
            make.trailing.equalTo(microphoneButton.snp.leading).offset(-Constants.spacing.small)
        }
        microphoneButton.snp.remakeConstraints { make in
            make.trailing.equalTo(layoutMarginsGuide)
            make.size.equalTo(addButton)
            make.top.bottom.equalTo(textField)
        }
    }
}
// MARK: - Delegate from TextField
extension ChatInputBarView: CustomTextFieldDelegate {
    func customTextFieldDidFillText(_ view: CustomTextField) {
        
    }
    func customTextFieldDidClearText(_ view: CustomTextField) {
        
    }
    func customTextFieldDidTapIcon(_ view: CustomTextField) {
        print("tap icon")
    }
}
