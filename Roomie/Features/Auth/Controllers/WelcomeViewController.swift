//
//  WelcomeViewController.swift
//  JLPT test
//
//  Created by Mu Yu on 18/5/21.
//

import UIKit
import Firebase
import GoogleSignIn

protocol WelcomeViewControllerDelegate: AnyObject {
    func welcomeViewControllerDidLoginSuccessfully(_ controller: WelcomeViewController)
}

class WelcomeViewController: ViewController {
    
    private let titleView = UILabel()
    private let googleLoginButton = TextButton(frame: .zero, buttonType: .primary)
    
    weak var delegate: WelcomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureGestures()
        configureConstraints()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
}
// MARK: - Actions
extension WelcomeViewController {
    private func didTapGoogleLogin() {
        GIDSignIn.sharedInstance().signIn()
    }

}
// MARK: - View Config
extension WelcomeViewController {
    private func configureViews() {
        titleView.text = "Roomie"
        titleView.font = UIFont.h2
        titleView.textColor = UIColor.label
        view.addSubview(titleView)
        
        googleLoginButton.tapHandler = {[weak self] in
            self?.didTapGoogleLogin()
        }
        googleLoginButton.text = "Continue with Google"
        view.addSubview(googleLoginButton)
    }
    private func configureGestures() {
        
    }
    private func configureConstraints() {
        titleView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
        googleLoginButton.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.layoutMarginsGuide)
        }
    }
}
extension WelcomeViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print("Login Successful.")
                self.delegate?.welcomeViewControllerDidLoginSuccessfully(self)
            }
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("user disconnected")
    }
}
