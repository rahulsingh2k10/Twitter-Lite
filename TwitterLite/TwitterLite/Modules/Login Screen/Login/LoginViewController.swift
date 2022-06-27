//
//  LoginViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 23/06/22.
//

import UIKit
import GoogleSignIn


class LoginViewController: BaseViewController<LoginViewModel> {
    @IBOutlet weak var googleSignInView: GIDSignInButton!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        googleSignInView.style = .wide
    }

    // MARK: - Button Action Methods -
    @IBAction func loginButtonClicked(_ sender: Any) {
        let signinVC = UIStoryboard(name: .Login).viewController(type: SigninViewController.self) as! SigninViewController

        present(signinVC, animated: true)
    }

    @IBAction func createAccountClicked(_ sender: Any) {
        let createAccountVC = UIStoryboard(name: .Login).viewController(type: CreateAccountViewController.self) as! CreateAccountViewController

        present(createAccountVC, animated: true)
    }

    @IBAction func googleSignInViewClicked(_ sender: Any) {
        viewModel?.signInToGoogle(viewController: self,
                                  didStartAuthCallback: {[weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.activityView.startAnimating()
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

                strongSelf.dismiss(animated: true)
            }
        }
    }
}
