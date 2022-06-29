//
//  LoginViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 23/06/22.
//

import UIKit
import GoogleSignIn


protocol LoginDelegate: AnyObject {
    func loginDidComplete()
}


class LoginViewController: BaseViewController<LoginViewModel> {
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var createAccountButton: UIButton!
    @IBOutlet weak private var googleSignInView: GIDSignInButton!

    public weak var loginDelegate: LoginDelegate?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        createAccountButton.tintColor = .systemBlue
        loginButton.tintColor = .systemBlue

        googleSignInView.style = .wide
    }

    // MARK: - Button Action Methods -
    @IBAction private func loginButtonClicked(_ sender: Any) {
        let signinVC = UIStoryboard(name: .Login).viewController(type: SigninViewController.self) as! SigninViewController
        signinVC.loginDelegate = self

        present(signinVC, animated: true)
    }

    @IBAction private func createAccountClicked(_ sender: Any) {
        let createAccountVC = UIStoryboard(name: .Login).viewController(type: CreateAccountViewController.self) as! CreateAccountViewController
        createAccountVC.loginDelegate = self

        present(createAccountVC, animated: true)
    }

    @IBAction private func googleSignInViewClicked(_ sender: Any) {
        viewModel?.signInToGoogle(viewController: self,
                                  didStartAuthCallback: {[weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.activityView.startAnimating(title: StringValue.loggingIn.rawValue)
        }) { [weak self] (user, error) in
            guard let strongSelf = self else { return }

            strongSelf.activityView.stopAnimating()

            if let error = error {
                let okAction = (UIAlertAction(title: StringValue.okTitle.rawValue,
                                              style: .default,
                                              handler: .none))

                strongSelf.presentAlert(message: error.localizedDescription, alertAction: [okAction])
            } else if let user = user {
                Utils.shared.loggedInUser = user

                strongSelf.loginDelegate?.loginDidComplete()
                strongSelf.dismiss(animated: true)
            }
        }
    }
}


extension LoginViewController: LoginDelegate {
    func loginDidComplete() {
        loginDelegate?.loginDidComplete()
    }
}
