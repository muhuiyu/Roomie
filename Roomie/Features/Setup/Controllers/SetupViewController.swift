//
//  SetupViewController.swift
//  Roomie
//
//  Created by Mu Yu on 28/7/21.
//

import UIKit

class SetupViewController: ViewController {
    private let newHouseholdButton = TextButton(frame: .zero, buttonType: .primary)
    private let joinHouseholdButton = TextButton(frame: .zero, buttonType: .primary)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureGestures()
        configureConstraints()
    }
}
// MARK: - View Config
extension SetupViewController {
    private func configureViews() {
        newHouseholdButton.text = "New Household"
        view.addSubview(newHouseholdButton)
        joinHouseholdButton.text = "Join Household"
        view.addSubview(joinHouseholdButton)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        newHouseholdButton.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(joinHouseholdButton)
            make.bottom.equalTo(joinHouseholdButton.snp.top).offset(-Constants.spacing.medium)
        }
        joinHouseholdButton.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
            make.bottom.equalTo(view.layoutMarginsGuide)
        }
    }
}

