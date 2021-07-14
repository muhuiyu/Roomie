//
//  ChatViewController.swift
//  Roomie
//
//  Created by Mu Yu on 2/7/21.
//

import UIKit

class ChatViewController: ViewController {
    private let tableView = UITableView()
    
    private let footerContainer = UIView()
    private let chatBarView = ChatInputBarView()
    private var footerBottomConstraint: NSLayoutConstraint? = nil
    
    var messages: [MessageEntry] = [
        MessageEntry(senderID: "me",
                     receiverID: "other",
                     content: .text(MessageContentTextEntry(value: "Hello")),
                     timestamp: Date().dayBefore),
        MessageEntry(senderID: "other",
                     receiverID: "me",
                     content: .text(MessageContentTextEntry(value: "Okay")),
                     timestamp: Date()),
        MessageEntry(senderID: "me",
                     receiverID: "other",
                     content: .image(MessageContentImageEntry(imageURL: "picture")),
                     timestamp: Date())
    ]
    
    override init() {
        super.init()
        tabBarItem = UITabBarItem(title: "Chat",
                                  image: UIImage(systemName: "bubble.left"),
                                  selectedImage: UIImage(systemName: "bubble.left.fill"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageTextCell.self, forCellReuseIdentifier: MessageTextCell.reuseID)
        tableView.register(MessageImageCell.self, forCellReuseIdentifier: MessageImageCell.reuseID)
        configureViews()
        configureGestures()
        configureConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightWillChange(note:)), name: UIView.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(note:)), name: UIView.keyboardWillHideNotification, object: nil)
    }
}
// MARK: - Keyboard
extension ChatViewController {
    @objc
    private func didTapBodyContainer() {
        dismissKeyboard()
    }
    @objc
    private func didSwipe(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == .down { dismissKeyboard() }
        }
    }
    @objc
    private func keyboardHeightWillChange(note: Notification) {
        guard let keyboardFrame = note.userInfo?[UIView.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        animateKeyboard(to: keyboardFrame.height, userInfo: note.userInfo)
    }
    @objc
    private func keyboardWillHide(note: Notification) {
        animateKeyboard(to: 0, userInfo: note.userInfo)
    }
    private func animateKeyboard(to height: CGFloat, userInfo: [AnyHashable : Any]?) {
        let duration = userInfo?[UIView.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        let animationCurveRawValue = userInfo?[UIView.keyboardAnimationCurveUserInfoKey] as? UIView.AnimationCurve.RawValue
        let animationOptions: UIView.AnimationOptions
        switch animationCurveRawValue {
        case UIView.AnimationCurve.linear.rawValue:
            animationOptions = .curveLinear
        case UIView.AnimationCurve.easeIn.rawValue:
            animationOptions = .curveEaseIn
        case UIView.AnimationCurve.easeOut.rawValue:
            animationOptions = .curveEaseOut
        case UIView.AnimationCurve.easeInOut.rawValue:
            animationOptions = .curveEaseInOut
        default:
            animationOptions = .curveEaseInOut
        }
        footerBottomConstraint?.constant = -height
        UIView.animate(withDuration: duration, delay: 0, options: [animationOptions, .beginFromCurrentState], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
// MARK: - Actions
extension ChatViewController {
    @objc
    private func didTapPhoneCall() {
        
    }
    @objc
    private func didTapVideoCall() {
        
    }
}
// MARK: - View Config
extension ChatViewController {
    private func configureViews() {
        title = "Chat"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "phone.fill"), style: .plain, target: self, action: #selector(didTapPhoneCall)),
            UIBarButtonItem(image: UIImage(systemName: "video.fill"), style: .plain, target: self, action: #selector(didTapVideoCall))
        ]
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.secondarySystemBackground
        view.addSubview(tableView)
        
        footerContainer.addSubview(chatBarView)
        view.addSubview(footerContainer)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        tableView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(chatBarView.snp.top)
        }
        chatBarView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        footerContainer.snp.remakeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            footerBottomConstraint = make.bottom.equalTo(view.layoutMarginsGuide).constraint.layoutConstraints.first
        }
    }
}

// MARK: - Data Source
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        switch message.content {
        case let .text(textEntry):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTextCell.reuseID, for: indexPath) as? MessageTextCell else { return UITableViewCell() }
            cell.content = textEntry
            
            if message.senderID == "me" {
                cell.source = .me
            }
            else {
                cell.source = .other
            }

            cell.entry = message
            cell.selectionStyle = .none
            return cell
        case let .image(imageEntry):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageImageCell.reuseID, for: indexPath) as? MessageImageCell else {
                return UITableViewCell()
            }
            cell.content = imageEntry
            cell.selectionStyle = .none
            return cell
        default: return UITableViewCell()
        }
    }
}
// MARK: - Delegate
extension ChatViewController: UITableViewDelegate {
    
}

