//
//  SigninViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 27/06/22.
//

import UIKit


class SigninViewController: BaseViewController<SigninViewModel> {
    override var desiredHeight: CGFloat {
        return 450.0
    }

    @IBOutlet weak private var emailAddressTextField: UITextField!

    public weak var loginDelegate: LoginDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        emailAddressTextField.becomeFirstResponder()
    }

    // MARK: - Action Methods -
    @IBAction private func textFieldChanged(_ sender: UITextField) {
        if let loginField = LoginField(rawValue: sender.tag) {
            switch loginField {
            case .emailAddress:
                viewModel?.userModel.emailAddress = sender.text
            case .password:
                viewModel?.userModel.password = sender.text
            default: break
            }
        }
    }

    @IBAction private func signinButtonClicked(_ sender: UIButton?) {
        do {
            try viewModel?.validateSiginUserModel()

            view.endEditing(true)

            activityView.startAnimating(title: StringValue.signingIn.rawValue)

            viewModel?.signInUser() { [weak self]user, error in
                guard let strongSelf = self else { return }

                strongSelf.activityView.stopAnimating()

                if let error = error {
                    strongSelf.presentAlert(message: error.localizedDescription)
                } else if let user = user {
                    Utils.shared.loggedInUser = user
                    strongSelf.loginDelegate?.loginDidComplete()
                    strongSelf.presentingViewController?.presentingViewController?.dismiss(animated: true)
                }
            }
        } catch (let error as LoginError) {
            presentAlert(message: error.errorDescription)
        } catch {
            presentAlert(message: error.localizedDescription)
        }
    }
}


extension SigninViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let loginField = LoginField(rawValue: textField.tag) {
            if loginField == .emailAddress {
                let textFields: [UITextField] = getAllSubviews(fromView: view)
                if let nextTextField = textFields.filter({ $0.tag == LoginField.password.rawValue }).first {
                    nextTextField.becomeFirstResponder()
                }
            } else {
                signinButtonClicked(.none)
            }
        }

        return true
    }
}
